module ApplicationHelper
    def active_class(path)
        "active-link" if current_page?(path)
    end
end
