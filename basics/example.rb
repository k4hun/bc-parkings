class Article
  attr_accessor :likes, :dislikes
  attr_reader :title, :body, :author, :created_at

  def initialize(title, body, author = nil)
    @title = title
    @body = body
    @author = author
    @created_at = Time.now
    @likes = 0
    @dislikes = 0
  end

  def like!
    @likes += 1
  end

  def dislike!
    @dislikes += 1
  end

  def points
    @likes - @dislikes
  end

  def votes
    @likes + @dislikes
  end

  def long_lines
    @body.lines.select { |line| line.length > 80 }
  end

  def length
    @body.length
  end

  def truncate(limit)
    if @body.length > limit
      @body[0, limit - 3] + '...'
    else
      @body
    end
  end

  def contain?(string)
    if body.index(string)
      true
    else
      false
    end
  end
end

class ArticlesFileSystem
  def initialize(directory_name)
    @directory_name = directory_name
  end

  def save(articles)
    articles.each do |article|
      file_name = @directory_name + '/' + article.title.downcase.tr(' ', '_') + '.article'
      file_content = "#{article.author}||#{article.likes}||#{article.dislikes}||#{article.body}"

      file = File.new(file_name, 'w')
      file << file_content
      file.close
    end
  end

  def load
    Dir["#{@directory_name}/*.article"].map do |dir|
      File.open(dir, 'r') do |file|
        file_title = File.basename(dir, '.article').capitalize.tr('_', ' ')
        article = file.read.split('||')
        art = Article.new(file_title, article[3], article[0])
        art.likes = article[1].to_i
        art.dislikes = article[2].to_i
        file.close

        art
      end
    end
  end
end

class WebPage
  attr_reader :articles

  def initialize(directory = '/')
    l = ArticlesFileSystem.new(directory)
    @articles = l.load
    @directory = directory
  end

  def load
    l = ArticlesFileSystem.new(@directory)
    @articles = l.load
  end

  def save(articles)
    l = ArticlesFileSystem.new(@directory)
    @articles = l.save
  end

  def new_article(title, body, author)
    article = Article.new(title, body, author)
    @articles << article
  end

  def longest_articles
    @articles.sort_by(&:length).reverse
  end

  def best_articles
    worst_articles.reverse
  end

  def worst_articles
    @articles.sort_by(&:points)
  end

  def raise_exception_when_no_article_found
    raise NoArticlesFound.new('No articles found!') unless @articles.any?
  end

  def best_article
    raise_exception_when_no_article_found
    best_articles.first
  end

  def worst_article
    raise_exception_when_no_article_found
    worst_articles.first
  end

  def most_controversial_articles
    @articles.sort_by(&:votes).reverse
  end

  def votes
    @articles.inject(0) { |sum, n| sum + n.votes }
  end

  def authors
    @articles.map { |article| article.author }.uniq
  end

  def authors_statistics
    stats = Hash.new { 0 }
    @articles.each do |article|
      stats[article.author] += 1
    end
    stats
  end

  def best_author
    authors_statistics.key(authors_statistics.values.max)
  end

  def search(query)
    @articles.select do |article|
      article.contain?(query)
    end
  end

  class NoArticlesFound < StandardError
    attr_reader :reason
    def initialize(reason)
      @reason = reason
    end
  end
end
