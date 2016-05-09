class Crawler
	include ActiveModel::Validations
  include ActiveWarnings
	include ActiveWarnings
	attr_accessor :id, :thumbnail, :image_url, :duration, :description, :watch_link,
								:title, :show_home_url, :show_name, :show_id, :episode, :season,
                :genre, :airdate, :host_name

  #presence
  validates :title, :id, :watch_link, :show_name, :show_home_url, presence: true

  #uniqueness
  validate do
    # if self.id && ObjectSpace.each_object(self.class).select{|o| o.id == self.id }.size > 1
    #   errors.add(:id,"not unique")
    # end

    # if self.show_id && ObjectSpace.each_object(self.class).select{|o| (o.show_id == self.show_id && o.show_name != self.show_name) }.size > 0
    #   errors.add(:show_name,"should be same")
    # end
  end

  #numericality
  validates :episode, :season, :duration, numericality: true, allow_blank: true

  validate :show_home_url_format, :watch_link_format, :title_rule

  warnings do
    validates :episode, :season, :duration, :airdate, presence: true
    validate { errors.add(:image_url, 'equals to thumbnail') if image_url == thumbnail  }
    validate :check_duration
  end

  def initialize(options, host_name)
  	@id = options['id']
    @title = options['title']
    @thumbnail = options['thumbnail']
    @image_url = options['image_url']
    @duration = options['duration']
    @description = options['description']
    @watch_link = options['watch_link']
    @show_home_url = options['show_home_url']
    @show_name = options['show_name']
    @show_id = options['show_id']
    @season = options['season']
    @episode = options['episode']
    @genre = options['genre']
    @airdate = options['airdate']
  	@host_name = host_name
  end

  def show_home_url_format
    errors.add(:show_home_url, 'Invalid format') if show_home_url && show_home_url.include?('http://')
  end

  def watch_link_format
  	unless watch_link.include?('http') || watch_link.include?(host_name)
  		errors.add(:watch_link, 'Invalid watch link')
  	end
  end

  def title_rule
    if title.include?(show_name) || title == host_name
      errors.add(:title, 'should not contain show name or site name')
    end
  end

  def check_duration
  	errors.add(:duration, 'episode should be greater than 900 seconds') if duration && duration < 900
  end

  def to_h
  	{ id: id, title: title, thumbnail: thumbnail, image_url: image_url,
  	  duration: duration, description: description, watch_link: watch_link,
  	  episode: episode, season: season, show_id: show_id, show_name: show_name,
  	  show_home_url: show_home_url, airdate: airdate, genre: 'TV'}
  end
end
