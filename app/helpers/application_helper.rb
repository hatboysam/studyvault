module ApplicationHelper
	def icon_class(type)
		if (type.include?("pdf"))
			return "icon-file icon-large"
		elsif (type.include?(".doc"))
			return "icon-file-alt icon-large"
		elsif (type.include?("presentation"))
			return "icon-list-alt icon-large"
		elsif (type.include?(".sheet"))
			return "icon-table icon-large"
		elsif (type.include?("image"))
			return "icon-camera icon-large"
		else
			return "icon-paper-clip icon-large"
		end
	end
end
