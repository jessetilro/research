module BibtexMappable
  extend ActiveSupport::Concern

  # specific for Source
  BIBTEX_MAPPING = {
    title: :title,
    author: :authors,
    year: :year,
    url: :url,
    abstract: :abstract,
    keywords: :keywords,
    bibtex_type: :bibtex_type,
    type: :bibtex_type,
    key: :bibtex_key,
    isbn: :isbn,
    doi: :doi,
    editors: :editors,
    booktitle: :subtitle,
    shorttitle: :shorttitle,
    month: :month,
    publisher: :publisher,
    institution: :institution,
    organization: :organization,
    address: :address,
    school: :school,
    edition: :edition,
    series: :series,
    chapter: :chapter,
    pages: :pages,
    journal: :journal,
    number: :number,
    volume: :volume,
    note: :note
  }

  included do
    before_save :decode_latex
    after_initialize :decode_latex
  end

  def self.included base
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end

  module InstanceMethods
    # Fix for nil mapping to default enum value
    # and conference mapping to inproceedings.
    def bibtex_type= value
      if value.try(:downcase).try(:to_sym) == :conference || value.to_sym == :conference
        super :inproceedings
      else
        super (value.nil? ? 0 : value)
      end
    end

    def to_bibtex
      mapped = (BIBTEX_MAPPING.except(:type, :key).map { |k, v| (self.send(v).present? ? {k => self.send(v)} : nil)  } - [nil]).reduce({}, :update)
      entry = BibTeX::Entry.new(mapped)
      entry.key = bibtex_key if bibtex_key.present?
      entry
    end

    def bibtex_text
    end

    def bibtex_text=(entry)
      assign_bibtex(entry)
    end

    def assign_bibtex(entry)
      return if entry.blank?
      assign_attributes(self.class.params_from_bibtex(entry))
    end

    protected

    def decode_latex
      BIBTEX_MAPPING.values.each do |field|
        self.send("#{field}=", LaTeX.decode(send(field)))
      end
    end
  end

  module ClassMethods
    def params_from_bibtex(entry)
      entry = BibTeX.parse entry if entry.is_a? String
      entry = entry.data[0] if entry.is_a? BibTeX::Bibliography
      return {} if entry.blank?
      entry_value = ->(bib) { ( entry[bib].try(:value) || entry.try(bib) || (bib == :bibtex_type && entry.type) || nil ) }
      params = (BIBTEX_MAPPING.map { |bib, src| { src => entry_value.call(bib) } }).reduce({}, :update)
      params.reject { |_,v| v.blank? }
    end

    def from_bibtex(entry)
      self.new(params_from_bibtex(entry))
    end

    def to_bibliography sources=nil
      sources ||= self.all
      bib = BibTeX::Bibliography.new
      sources.each { |src| bib << src.to_bibtex }
      bib
    end

    def from_bibliography bib
      bib = BibTeX.parse bib if bib.is_a? String
      bib.data.map do |entry|
        self.from_bibtex entry
      end
    end
  end
end
