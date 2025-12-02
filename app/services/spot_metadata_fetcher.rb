# frozen_string_literal: true

require 'open-uri'

class SpotMetadataFetcher
  MAX_TITLE_LENGTH       = 20   # nokogiriの取得文字数制限（title)
  MAX_DESCRIPTION_LENGTH = 200  # nokogiriの取得文字数制限（description)
  def self.call(url)
    new(url).call
  end

  def initialize(url)
    @original_url = url
    @uri = parse_url(url)
  end

  def call
    return {} unless @uri

    html = fetch_html(@uri)
    return {} unless html

    extract_metadata(html)
  rescue StandardError => e
    log_error(e)
    {}
  end

  private

  def extract_metadata(html)
    doc = Nokogiri::HTML.parse(html)

    {
      title: presence_or_nil(extract_title(doc)),
      description: presence_or_nil(extract_description(doc)),
      image_url: presence_or_nil(extract_image_url(doc))
    }
  end

  def extract_title(doc)
    og_content(doc, 'og:title') || doc.at('title')&.text&.strip
  end

  def extract_description(doc)
    og_content(doc, 'og:description') || meta_content(doc, 'description')
  end

  def extract_image_url(doc)
    og_content(doc, 'og:image')
  end

  def parse_url(url)
    uri = URI.parse(url)
    return nil unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)

    uri
  rescue URI::InvalidURIError
    nil
  end

  def fetch_html(uri)
    # User-Agentないと弾かれるサイトもあるので一応実装する
    # rubocop:disable Security/Open
    URI.open(
      uri.to_s,
      'User-Agent' => 'Mozilla/5.0 (AiRoute metadata bot)',
      read_timeout: 5
    ).read
    # rubocop:enable Security/Open
  rescue StandardError => e
    Rails.logger.warn("[SpotMetadataFetcher] fetch error: #{e.class}: #{e.message}")
    nil
  end

  def og_content(doc, property_name)
    doc.at(%(meta[property="#{property_name}"]))&.[]('content')&.strip
  end

  def meta_content(doc, name)
    doc.at(%(meta[name="#{name}"]))&.[]('content')&.strip
  end

  def presence_or_nil(str)
    str.present? ? str : nil
  end

  def truncate_text(str, max_length)
    return nil if str.blank?

    normalized = str.gsub(/\s+/, ' ').strip # 改行や連続スペースを1つにする設定
    return normalized if normalized.length <= max_length

    "#{normalized[0, max_length]}…"
  end

  def log_error(error)
    Rails.logger.error(
      "[SpotMetadataFetcher] #{error.class}: #{error.message} (url=#{@original_url})"
    )
  end
end
