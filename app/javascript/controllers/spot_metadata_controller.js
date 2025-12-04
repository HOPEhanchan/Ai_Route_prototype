import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "url",
    "title",
    "description",
    "imageUrl",
    "imagePreviewWrapper",
    "imagePreview"
  ]
  //コピペ投下でnokogiri自動でかかる設定
  handlePaste(event) {
    // paste イベントのタイミングだと、まだ value が更新されていないことがあるので
    // 少しだけ遅らせてから fetchMetadata を呼ぶ　というロジック。
    setTimeout(() => this.fetchMetadata(), 0)
  }


  // URL入力後にnokogiri呼び出す設定
  async fetchMetadata(event) {
    const url = this.urlTarget.value.trim()
    if (url === "") return

    const overlay = document.getElementById("spot-loading-overlay")

    const showOverlay = () => overlay?.classList.remove("hidden")
    const hideOverlay = () => overlay?.classList.add("hidden")

    showOverlay()

    try {
      const resp = await fetch(
        `/spots/fetch_metadata?url=${encodeURIComponent(url)}`,
        { headers: { "Accept": "application/json" } }
      )

      if (!resp.ok) {
        console.warn("metadata fetch failed", resp.status)
        return
      }

      const data = await resp.json()

      // すでにユーザーがformを入力してたら上書きしない設定
      if (this.hasTitleTarget && this.titleTarget.value.trim() === "" && data.title) {
        this.titleTarget.value = data.title
      }

      if (this.hasDescriptionTarget && this.descriptionTarget.value.trim() === "" && data.description) {
        this.descriptionTarget.value = data.description
      }

      if (this.hasImageUrlTarget && this.imageUrlTarget.value.trim() === "" && data.image_url) {
        this.imageUrlTarget.value = data.image_url
      }

      // 👇 画像プレビューを更新する設定
      if (data.image_url && this.hasImagePreviewTarget && this.hasImagePreviewWrapperTarget) {
        this.imagePreviewTarget.src = data.image_url
        this.imagePreviewWrapperTarget.classList.remove("hidden")
      }
    } catch (e) {
      console.error("metadata fetch error", e)
    } finally {
      hideOverlay()
    }
  }
  // 画像URLが入力されたとき更新する
  updateImagePreview() {
    if (!this.hasImagePreviewTarget || !this.hasImagePreviewWrapperTarget) return

    const url = this.imageUrlTarget.value.trim()

    if (url === "") {
      this.imagePreviewWrapperTarget.classList.add("hidden")
      this.imagePreviewTarget.src = ""
      return
    }

  // プレビュー表示
    this.imagePreviewTarget.src = url
    this.imagePreviewWrapperTarget.classList.remove("hidden")
  }
}
