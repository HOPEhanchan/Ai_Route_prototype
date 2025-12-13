import { Controller } from "@hotwired/stimulus"

// data-controller="input-clear" 用
export default class extends Controller {
  static targets = ["input", "clear"]

  connect() {
    // デバッグ用↓↓↓
    console.log(" @@@ input-clear connected", this.element)

    this.refresh()
  }
    // 初期表示時にボタン表示/非表示を決める
    // this.toggle("input-clear connected", this.element)


  // 入力値に応じて X ボタンの表示を切り替え
  refresh() {
    if (!this.hasInputTarget || !this.hasClearTarget) {

      return
    }

    const empty = this.inputTarget.value.trim() === ""
    this.clearTarget.classList.toggle("hidden", empty)
  }

  // 入力中に呼ばれる（data-action="input->input-clear#refresh" にする）
  toggle() {
    this.refresh()
  }

  // クリア処理
  clear(event) {
    event.preventDefault()

    if (!this.hasInputTarget || !this.hasClearTarget) return

    console.log("@@@ clear clicked", this.inputTarget)

    this.inputTarget.value = ""
    this.refresh()
    this.inputTarget.focus()

    // 他の controller（spot-metadata など）が input を監視してる場合があるので、 input イベントを発火させる
    this.inputTarget.dispatchEvent(new Event("input", { bubbles: true }))
  }
}
