class MessagesController < ApplicationController
  def show
    @booking = Booking.find(params[:id])
    @message = Message.new
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @message = Message.new(message_params)
    @message.booking = @booking
    @message.user = current_user

    if @message.save
      BookingChannel.broadcast_to(
        @booking,
        render_to_string(partial: "message", locals: { message: @message })
      )
      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to booking_path(@booking) }
        format.json { render json: @message, status: :created }
      end
    else
      respond_to do |format|
        format.html { render "bookings/show", status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # def create
  #   @booking = Booking.find(params[:booking_id])
  #   @message = Message.new(message_params)
  #   @message.booking = @booking
  #   @message.user = current_user
  #   if @message.save
  #     BookingChannel.broadcast_to(
  #       @booking,
  #       render_to_string(partial: "message", locals: {message: @message})
  #     )
  #     head :ok
  #   else
  #     render "bookings/show", status: :unprocessable_entity
  #   end
  # end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
