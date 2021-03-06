class HomeSlide < ApplicationRecord
  belongs_to :event, inverse_of: :home_slides, optional: true
  belongs_to :category, inverse_of: :home_slides, optional: true

  mount_uploader :huge_image, HugeHomeSlideImageUploader
  mount_uploader :avatar, AvatarUploader
  mount_uploader :big_image, BigHomeSlideImageUploader
  mount_uploader :tile_image, TileHomeSlideImageUploader

  KIND_TOP_SLIDE = 0
  KIND_FEATURED_EVENT = 1
  KIND_TOP_EVENT = 2
  KIND_POPULAR_EVENT = 3

  validates :kind, presence: true

  validates :huge_image, presence: true, if: Proc.new { |a| a.kind == HomeSlide::KIND_TOP_SLIDE }
  validates :avatar, presence: true,     if: Proc.new { |a| a.kind == HomeSlide::KIND_FEATURED_EVENT }
  validates :big_image, presence: true,  if: Proc.new { |a| a.kind == HomeSlide::KIND_TOP_EVENT }
  validates :tile_image, presence: true, if: Proc.new { |a| a.kind == HomeSlide::KIND_POPULAR_EVENT }

  validates :event, presence: true, if: Proc.new { |a| !a.manual_input? }

  validates :title, :url, presence: true, if: :manual_input?

  before_save :clean_unused_fields

  scope :ordered, -> { order(prior: :asc, id: :asc) }

  def image
    case kind
    when KIND_TOP_SLIDE
      huge_image
    when KIND_FEATURED_EVENT
      avatar.grid_small
    when KIND_TOP_EVENT
      big_image.the_first
    when KIND_POPULAR_EVENT
      tile_image
    end
  end

  def view_title; manual_input? ? title : event.name end
  def view_place
    if manual_input?
      place
    else
      event.venue ? [event.venue.city, event.venue.country].join(', ') : nil
    end
  end
  def view_start_date; manual_input? ? start_date : event.start_time end
  def view_end_date; manual_input? ? end_date : nil end
  def view_category; manual_input? ? category : event.category end

  private

  # before save
  def clean_unused_fields
    remove_huge_image! if huge_image.present? && kind != HomeSlide::KIND_TOP_SLIDE
    remove_avatar! if avatar.present? && kind != HomeSlide::KIND_FEATURED_EVENT
    remove_big_image! if big_image.present? && kind != HomeSlide::KIND_TOP_EVENT
    remove_tile_image! if tile_image.present? && kind != HomeSlide::KIND_POPULAR_EVENT

    if manual_input?
      self.event = nil unless event.nil?
    else
      self.title = nil unless title.nil?
      self.url = nil unless url.nil?
      self.place = nil unless place.nil?
      self.start_date = nil unless start_date.nil?
      self.end_date = nil unless end_date.nil?
      self.category = nil unless category.nil?
    end
  end
end
