module Referrable
  extend ActiveSupport::Concern
  # depends on BibtexMappable

  DEFAULT_OPTIONS = { style: 'apa', format: 'text' }

  def reference_text
  end

  def reference_text=(ref)
    assign_reference(ref)
  end

  def assign_reference(ref)
    entry = AnyStyle.parse(ref, format: :bibtex)
    assign_bibtex(entry)
  end

  def to_reference options={}
    cp = CiteProc::Processor.new DEFAULT_OPTIONS.merge(options)
    item = CiteProc::Item.new(to_bibtex.to_citeproc)
    node = cp.engine.style.bibliography
    cp.engine.renderer.render_bibliography item.cite, node
  end
end
