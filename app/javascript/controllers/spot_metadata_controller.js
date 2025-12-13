import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "url",
    "title",
    "description",
    "memo",
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

      // 画像プレビューを更新する設定
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

  clearImage() {
    if (this.hasImageUrlTarget) {
      this.imageUrlTarget.value = ""
      this.imageUrlTarget.dispatchEvent(new Event("input", { bubbles: true }))
    }

    if (this.hasImagePreviewTarget && this.hasImagePreviewWrapperTarget) {
      this.imagePreviewTarget.src = ""
      this.imagePreviewWrapperTarget.classList.add("hidden")
    }
  }

  // 自動入力された内容（title / description / image_url / preview）をまとめてクリアするボタン
  clearAutoFilled() {
    if (this.hasTitleTarget) this.titleTarget.value = ""
    if (this.hasDescriptionTarget) this.descriptionTarget.value = ""
    if (this.hasImageUrlTarget) this.imageUrlTarget.value = ""

    if (this.hasImagePreviewTarget && this.hasImagePreviewWrapperTarget) {
        this.imagePreviewTarget.src = ""
        this.imagePreviewWrapperTarget.classList.add("hidden")
    }
  }

 // ===== 各項目のクリアボタン設定 =====
  clearUrlField() {
    if (!this.hasUrlTarget) return
    this.urlTarget.value = ""
    this.urlTarget.focus()
  }

  clearTitleField() {
    if (!this.hasTitleTarget) return
    this.titleTarget.value = ""
    this.titleTarget.focus()
  }

  clearDescriptionField() {
    if (!this.hasDescriptionTarget) return
    this.descriptionTarget.value = ""
    this.descriptionTarget.focus()
  }

  clearMemoField() {
    if (!this.hasMemoTarget) return
    this.memoTarget.value = ""
    this.memoTarget.focus()
  }

  // 画像URL + プレビュー両方クリア
  clearImageUrlField() {
    if (this.hasImageUrlTarget) {
      this.imageUrlTarget.value = ""
    }
    this.updateImagePreview()
  }

  // プレビューだけ消したい時用（image_url は残す）
  clearImagePreviewOnly() {
    if (!this.hasImagePreviewTarget || !this.hasImagePreviewWrapperTarget) return

    this.imagePreviewTarget.src = ""
    this.imagePreviewWrapperTarget.classList.add("hidden")
  }
}
