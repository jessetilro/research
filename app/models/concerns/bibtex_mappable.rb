# uses BibTeX as intermediate form to render references.
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

  def self.included base
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end

  module InstanceMethods
    def to_bibtex
      mapped = (BIBTEX_MAPPING.map { |k, v| (self.send(v).present? ? {k => self.send(v)} : nil)  } - [nil]).reduce({}, :update)
      BibTeX::Entry.new(mapped)
    end
  end

  module ClassMethods
    def from_bibtex entry
      entry = BibTeX.parse entry if entry.is_a? String
      entry = entry.data[0] if entry.is_a? BibTeX::Bibliography
      entry_value = ->(bib) { ( entry[bib].try(:value) || entry.try(bib) || (bib == :bibtex_type && entry.type) || nil ) }
      params = (BIBTEX_MAPPING.map { |bib, src| { src => entry_value.call(bib) } }).reduce({}, :update)
      self.new(params)
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
