class ErrorSerializer
  def initialize(error)
    @error = error
  end

  def serialized_json
    {
      data: [{
        type: 'error',
        id: nil,
        attributes: {}
      }],

      errors: [
        {
          status: '404',
          title: @error.class,
          detail: @error.message
        }
      ]
    }
  end
end
