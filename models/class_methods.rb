class Class
  def column(*columns)
    columns.each do |column|
      self.class_eval("
        @columns << '#{column}'
        attr_accessor '#{column}'
      ")
    end
  end

  def foreign_key(*models)
    models.each do |model|
      self.class_eval("
        column '#{model.downcase}_id'
        def #{model.downcase}
          foreign_key_select_single('#{model}')
        end
      ")
    end
  end
end
