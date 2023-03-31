# frozen_string_literal: true

class ErrorPoro
  attr_reader :message, :status

  def initialize(message, status)
    @message = message
    @status = status
  end

  def serialize
    {
      data: [{
        type: 'error',
        id: nil,
        attributes: {}
      }],

      errors: [
        {
          status: @status,
          title: @message,
          detail: @message
        }
      ]
    }
  end

  def cerealize
    {
      data: {
        type: 'error',
        id: nil,
        attributes: {}
      },

      errors: [
        {
          status: @status,
          title: @message,
          detail: @message
        }
      ]
    }
  end
end
