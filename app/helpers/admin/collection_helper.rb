module Admin::CollectionHelper

  def courses_by_university(university)
    Course.by_university(university).order_by_name
  end

end
