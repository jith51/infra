# frozen_string_literal: true

# Controller pour les indicateurs
class IndicateursController < ApplicationController
  # before_action :authenticate

  def dna
    nombre_app_profiles = Apic::ApplicationProfile.count + 1 # +1 pour le L3OUT

      nombre_app_profiles_avec_legacy = Apic::Contrat.find_by(name: 'LEGACY').used_contrats.includes(
        contractable: :application_profile).map do |used_contrat|
          return used_contrat.contractable_type == "Apic::Epg" ? used_contrat.contractable.application_profile.name :  "L3OUT"
      end.uniq().count

      render json: {
        nombre_app_profiles: nombre_app_profiles,
        nombre_app_profiles_avec_legacy: nombre_app_profiles_avec_legacy
      }
  end
end
