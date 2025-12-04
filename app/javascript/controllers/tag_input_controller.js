import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chips", "input", "hidden"]
  static values = {
    initialTags: String
  }

  connect() {
    // 初期タグ（"デート, 夜景" など）を配列にパース
    this.tags = this.parseTags(this.initialTagsValue || "")
    this.renderChips()
    this.syncHidden()
  }

  // 文字列 → 例　["デート", "夜景"]
  parseTags(str) {
    return (str || "")
      .split(/[,\s、\u3000]+/) // カンマ / スペース / 日本語読点 / 全角スペース で分割
      .map((s) => s.trim())
      .filter((s) => s.length > 0)
      .filter((v, i, arr) => arr.indexOf(v) === i) // uniq
  }

  // hidden に "デート, 夜景" みたいに入れる
  syncHidden() {
    if (!this.hasHiddenTarget) return
    this.hiddenTarget.value = this.tags.join(", ")
  }

  // 画面上のチップ再描画
  renderChips() {
    if (!this.hasChipsTarget) return

    this.chipsTarget.innerHTML = ""

    this.tags.forEach((name) => {
      const wrapper = document.createElement("span")
      wrapper.className =
        "inline-flex items-center gap-1 px-2 py-1 rounded-full " +
        "bg-emerald-50 border border-emerald-200 text-[11px] text-emerald-700"

      // ラベル
      const label = document.createElement("span")
      label.textContent = name

      // ×ボタン -> タグチップの削除
      const button = document.createElement("button")
      button.type = "button"
      button.textContent = "×"
      button.className =
        "ml-1 text-[10px] text-emerald-500 hover:text-emerald-700"
      button.dataset.action = "click->tag-input#removeTag"
      button.dataset.name = name

      wrapper.appendChild(label)
      wrapper.appendChild(button)

      this.chipsTarget.appendChild(wrapper)
    })
  }

  // Enter / スペース / カンマ で確定
  handleKeydown(event) {
    const key = event.key

    if (key === "Enter" || key === " " || key === "Spacebar" || key === "," || key === "、") {
      event.preventDefault()
      this.commitInput()
    }
  }

  commitInput() {
    if (!this.hasInputTarget) return
    const raw = this.inputTarget.value

    if (!raw || raw.trim() === "") return

    const newNames = this.parseTags(raw)

    if (newNames.length === 0) {
      this.inputTarget.value = ""
      return
    }

    this.tags = Array.from(
      new Set([...this.tags, ...newNames])
    )

    this.inputTarget.value = ""
    this.renderChips()
    this.syncHidden()
  }

  // × を押したとき
  removeTag(event) {
    const name = event.currentTarget.dataset.name
    this.tags = this.tags.filter((t) => t !== name)
    this.renderChips()
    this.syncHidden()
  }
}
