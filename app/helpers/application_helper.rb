# encoding: utf-8
module ApplicationHelper

  # FULL_TITLE HELPER
  # Gibt den vollen Titel der Seite zurück, zusammengesetzt aus einem
  # Basistitel und dem viá Provide vom Template, Partial, oder Controller zur
  # Verfuegung gestellten Seitentitel

  def full_title(page_title)
    base_title = "Uli Hannemann blökt"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
