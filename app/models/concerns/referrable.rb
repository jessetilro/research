module Referrable
  extend ActiveSupport::Concern

  DEFAULT_OPTIONS = { style: 'apa', format: 'text' }

  # uses BibTeX as intermediate form to render references.
  def reference options={}
    cp = CiteProc::Processor.new DEFAULT_OPTIONS.merge(options)
    item = CiteProc::Item.new(to_bibtex.to_citeproc)
    node = cp.engine.style.bibliography
    cp.engine.renderer.render_bibliography item.cite, node
  end

end
