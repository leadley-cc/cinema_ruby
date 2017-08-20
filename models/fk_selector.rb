class Class
  def fk_selector(*models)
    models.each do |model|
      self.class_eval("
        def #{model.downcase}
          foreign_key_select_single('#{model}')
        end
      ")
    end
  end
end
