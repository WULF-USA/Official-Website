require_relative './spec_helper'
require 'i18n-spec'

describe "i18n/en.yml" do
    it { is_expected.to be_parseable }
end

describe "i18n/es.yml" do
  xit { is_expected.to be_a_complete_translation_of 'i18n/en.yml' }
end

describe "i18n/ru.yml" do
  it { is_expected.to be_a_complete_translation_of 'i18n/en.yml' }
end

describe "i18n/fr.yml" do
  xit { is_expected.to be_a_complete_translation_of 'i18n/en.yml' }
end
