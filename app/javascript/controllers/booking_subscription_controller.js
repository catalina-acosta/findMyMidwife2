import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"
// Connects to data-controller="booking-subscription"
export default class extends Controller {
  static values = { bookingId: Number }
  static targets = ["messages"]

  connect() {
    // console.log('hi from connect')
    this.channel = createConsumer().subscriptions.create(
      { channel: "BookingChannel", id: this.bookingIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
    // console.log(`Subscribe to the chatroom with the id ${this.bookingIdValue}.`)
  }

  #insertMessageAndScrollDown(data) {
    console.log('hi from scrolldown')
    this.messagesTarget.insertAdjacentHTML("beforeend", data)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  resetForm(event) {
    console.log('hi from reset')
    event.target.reset()
  }

  disconnect() {
    // console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }
}
