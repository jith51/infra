# frozen_string_literal: true

# Creation des connections
class CreatePhysicalConnection < ActiveRecord::Migration[8.1]
  def up
    create_table :physical_link_types do |t|
      t.string :name, null: false, index: true
    end
    create_table :physical_connections, id: false do |t|
      t.references :local_port, null: false, foreign_key: {
        to_table: :physical_ports,
        on_delete: :cascade
      }
      t.references :distant_port, null: false, foreign_key: {
        to_table: :physical_ports,
        on_delete: :cascade
      }
      t.belongs_to :link_type, null: true, foreign_key: {
        to_table: :physical_link_types,
        on_delete: :restrict
      }

      t.index %i[local_port_id distant_port_id], unique: true
    end
    create_connection_symetry_trigger
  end

  def down
    drop_table :physical_link_types
    execute <<~SQL
      DROP TABLE physical_connections CASCADE
    SQL
  end

  def create_connection_symetry_trigger
        # Création du trigger INSERT
    execute <<~SQL
      CREATE OR REPLACE FUNCTION create_reverse_physical_connection()
      RETURNS TRIGGER AS $$
      BEGIN
        IF pg_trigger_depth() > 1 THEN
          RETURN NEW;
        END IF;

        INSERT INTO physical_connections (
          local_port_id,
          distant_port_id,
          link_type_id
        )
        VALUES (
          NEW.distant_port_id,
          NEW.local_port_id,
          NEW.link_type_id
        )
        ON CONFLICT (local_port_id, distant_port_id)
        DO UPDATE SET
          link_type_id = EXCLUDED.link_type_id;

        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    execute <<~SQL
      CREATE TRIGGER physical_connections_create_reverse
      AFTER INSERT ON physical_connections
      FOR EACH ROW
      EXECUTE FUNCTION create_reverse_physical_connection();
    SQL

    # Création du trigger UPDATE
    execute <<~SQL
      CREATE OR REPLACE FUNCTION update_reverse_physical_connection()
      RETURNS TRIGGER AS $$
      BEGIN
        IF pg_trigger_depth() > 1 THEN
          RETURN NEW;
        END IF;

        IF OLD.local_port_id <> NEW.local_port_id
           OR OLD.distant_port_id <> NEW.distant_port_id THEN

          DELETE FROM physical_connections
          WHERE local_port_id = OLD.distant_port_id
            AND distant_port_id = OLD.local_port_id;

          INSERT INTO physical_connections (
            local_port_id,
            distant_port_id,
            link_type_id
          )
          VALUES (
            NEW.distant_port_id,
            NEW.local_port_id,
            NEW.link_type_id
          )
          ON CONFLICT (local_port_id, distant_port_id)
          DO UPDATE SET
            link_type_id = EXCLUDED.link_type_id;

        ELSE
          UPDATE physical_connections
          SET link_type_id = NEW.link_type_id
          WHERE local_port_id = OLD.distant_port_id
            AND distant_port_id = OLD.local_port_id;
        END IF;

        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    execute <<~SQL
      CREATE TRIGGER physical_connections_update_reverse
      AFTER UPDATE OF local_port_id, distant_port_id, link_type_id
      ON physical_connections
      FOR EACH ROW
      EXECUTE FUNCTION update_reverse_physical_connection();
    SQL

    # Création du trigger DELETE
    execute <<~SQL
      CREATE OR REPLACE FUNCTION delete_reverse_physical_connection()
      RETURNS TRIGGER AS $$
      BEGIN
        IF pg_trigger_depth() > 1 THEN
          RETURN OLD;
        END IF;

        DELETE FROM physical_connections
        WHERE local_port_id = OLD.distant_port_id
          AND distant_port_id = OLD.local_port_id;

        RETURN OLD;
      END;
      $$ LANGUAGE plpgsql;
    SQL

    execute <<~SQL
      CREATE TRIGGER physical_connections_delete_reverse
      AFTER DELETE ON physical_connections
      FOR EACH ROW
      EXECUTE FUNCTION delete_reverse_physical_connection();
    SQL
  end
end
