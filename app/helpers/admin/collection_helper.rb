module Admin::CollectionHelper

  def courses_by_university(university)
    return [] unless university
    Course.by_university(university).order_by_name
  end

  def school_classes_by_university(university)
    return [] unless university
    SchoolClass.by_university(university)
  end

  def school_classes_years(university)
    years      = map_year(school_classes_by_university(university))
    uniq_years = collection_with_uniq_elements(years)
    sorted_collection(uniq_years)
  end

  private

  def sorted_collection(collection)
    collection.sort! { |a,b| a <=> b }
  end

  def collection_with_uniq_elements(collection)
    collection.uniq
  end

  def map_year(collection)
    collection.map{ |elem| [elem.year, elem.year] }
  end
end
