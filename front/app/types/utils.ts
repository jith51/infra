import * as v from 'valibot'

export function arraySchemaWithUniqueName<T extends { name: string }>(
  schema: v.GenericSchema<T>,
  message = "Chaque attribut doit avoir un nom unique."
) {
    return v.pipe(
        v.array(schema),
        v.custom<T[]>(
        (items: unknown): items is T[] => {
            const values = items as T[];
            const names = values.map((item) => item.name);
            // debugger
            return new Set(names).size === names.length;
        },
        message
        )
    );
}

export function arraySchemaWithUniqueNameAndForbiddenNames<T extends { name: string }>(
  schema: v.GenericSchema<T>,
  forbiddenNames: string[] = [],
  message = 'Chaque attribut doit avoir un nom unique.',
) {
  return v.pipe(
    v.array(schema),

    v.check(
      (items) => {
        const names = items.map(item => item.name)

        return new Set(names).size === names.length
      },
      message,
    ),

    v.check(
      (items) => {
        const forbidden = new Set(forbiddenNames)

        return items.every(item => !forbidden.has(item.name))
      },
      'Cet attribut existe déjà dans un parent.',
    ),
  )
}