module DatasetProcessorHelper

  def generate_dataset(generator)
    return [] if generator.blank?
    range_str, size_str = generator.split(",")
    min, max = range_str.strip.split("-").map(&:to_i)
    size = size_str.strip.match(/size=(\d+)/)[1].to_i
    Array.new(size) { rand(min..max) }
  end

  def compute_dataset_answer(dataset, strategy)
    return nil if dataset.blank?

    case strategy
    when "mean"
      (dataset.sum.to_f / dataset.size).round(2)
    when "median"
      sorted = dataset.sort
      mid = dataset.length / 2
      dataset.length.odd? ? sorted[mid] : ((sorted[mid - 1] + sorted[mid]) / 2.0).round(2)
    when "mode"
      dataset.group_by(&:itself).values.max_by(&:size).first
    when "range"
      dataset.max - dataset.min
    when "standard_deviation"
      m = dataset.sum.to_f / dataset.size
      Math.sqrt(dataset.sum { |x| (x - m) ** 2 } / dataset.size).round(2)
    when "variance"
      m = dataset.sum.to_f / dataset.size
      (dataset.sum { |x| (x - m) ** 2 } / dataset.size).round(2)
    else
      nil
    end
  end
end
