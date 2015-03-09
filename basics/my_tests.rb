require 'minitest/autorun'
require './example'

class ArticleTest < Minitest::Test
  def setup
    @article = Article.new("Title", "Body", "Author")
    @turncate = Article.new("Title", "Test for truncate method", "Author")
  end

  def test_initialization
    assert_equal("Title", @article.title)
    assert_equal("Body", @article.body)
    assert_equal("Author", @article.author)
    assert_in_delta(@article.created_at, Time.now, 0.01)
    assert_equal(0, @article.likes)
    assert_equal(0, @article.dislikes)
  end

  def test_initialization_with_anonymous_author
    article = Article.new("Title", "Body", "")
    assert_equal("Title", article.title)
    assert_equal("Body", article.body)
    assert_equal("", article.author)
    assert_in_delta(@article.created_at, Time.now, 0.01)
    assert_equal(0, article.likes)
    assert_equal(0, article.dislikes)
  end

  def test_liking
    3.times { @article.like! }
    assert_equal(3, @article.likes)
  end

  def test_disliking
    4.times { @article.dislike! }
    assert_equal(4, @article.dislikes)
  end

  def test_points
    @article.likes = 4
    @article.dislikes = 2
    assert_equal(2, @article.points)
  end

  def test_long_lines
    article = Article.new("Title", "****10****"*8 + "\n" + "****10****" + "\n" + "****11****"*9, "Author")
    assert_equal(["****10****"*8 + "\n", "****11****"*9], article.long_lines)
  end

  def test_truncate
    assert_equal("Test for...", @turncate.truncate(11))
  end

  def test_truncate_when_limit_is_longer_then_body
    assert_equal("Test for truncate method", @turncate.truncate(80))
  end

  def test_truncate_when_limit_is_same_as_body_length
    assert_equal("Test for truncate method", @turncate.truncate(24))
  end

  def test_length
    assert_equal(4, @article.length)
  end

  def test_votes
    @article.likes = 4
    @article.dislikes = 2
    assert_equal(6, @article.votes)
  end

  def test_contain
    article = Article.new("Title", "This is contain test", "Author")
    assert_equal(true, article.contain?("test"))
  end
end

class ArticlesFileSystemTest < Minitest::Test

  def setup
    @dir = Dir.mktmpdir()
    @files = ArticlesFileSystem.new(@dir)
  end

  def teardown
    FileUtils::rm_rf(@dir)
  end

  def test_saving
    @articles = [Article.new("Title 1", "Body_1", "Author_1"), Article.new("Title 2", "Body_2", "Author_2")]
    @files.save(@articles)

    assert(File.exist?("#{@dir}/title_1.article"))
    assert_equal('Author_1||0||0||Body_1', File.read("#{@dir}/title_1.article"))

    assert(File.exist?("#{@dir}/title_2.article"))
    assert_equal('Author_2||0||0||Body_2', File.read("#{@dir}/title_2.article"))
  end

  def test_loading
    File.write("#{@dir}/test_1.article", "Author_1||0||0||Body_1")
    File.write("#{@dir}/test_2", 'Some glorious content')
    articles = @files.load

    assert_equal(['Test 1'], articles.map(&:title))
    assert_equal(['Body_1'], articles.map(&:body))
    assert_equal(['Author_1'], articles.map(&:author))
    assert_equal([0], articles.map(&:likes))
    assert_equal([0], articles.map(&:dislikes))
  end
end

class WebPageTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir

    File.write("#{@dir}/title_1.article", 'Author_1||3||2||Nullam dapibus maximus massa sed venenatis.')
    File.write("#{@dir}/title_2.article", 'Author_2||2||5||Aenean ac velit dignissim, facilisis quam at, condimentum libero.')
    File.write("#{@dir}/title_3.article", 'Author_2||0||5||Aenean in magna diam.')

    @page = WebPage.new(@dir)
  end

  def teardown
    FileUtils::rm_rf @dir
  end

  def test_new_without_anything_to_load
    Dir.mktmpdir do |tmp|
      newpage = WebPage.new(tmp)
      assert_empty newpage.articles
    end
  end

  def test_new_article
    new_article = @page.new_article('Title', 'Body', 'Author')
    assert_equal(4, @page.articles.size)
    refute File.exist?("#{@dir}/title.article}")
  end

  def test_longest_articles
    assert_equal(['Title 2', 'Title 1', 'Title 3'], @page.longest_articles.map(&:title))
  end

  def test_best_articles
    assert_equal(['Title 1', 'Title 2', 'Title 3'], @page.best_articles.map(&:title))
  end

  def test_best_article
    assert_equal('Title 1', @page.best_article.title)
  end

  def test_best_article_exception_when_no_articles_can_be_found
    Dir.mktmpdir do |tmp|
      newpage = WebPage.new(tmp)
      assert_raises(WebPage::NoArticlesFound) { newpage.best_article }
    end
  end

  def test_worst_articles
    assert_equal(['Title 3', 'Title 2', 'Title 1'], @page.worst_articles.map(&:title))
  end

  def test_worst_article
    assert_equal('Title 3', @page.worst_article.title)
  end

  def test_worst_article_exception_when_no_articles_can_be_found
    Dir.mktmpdir do |tmp|
      newpage = WebPage.new(tmp)
      assert_raises(WebPage::NoArticlesFound) { newpage.worst_article }
    end
  end

  def test_most_controversial_articles
    assert_equal(['Title 2', 'Title 3', 'Title 1'], @page.most_controversial_articles.map(&:title))
  end

  def test_votes
    assert_equal(17, @page.votes)
  end

  def test_authors
    assert_equal(['Author_1', 'Author_2'], @page.authors)
  end

  def test_authors_statistics
    stats = { 'Author_1' => 1,
              'Author_2' => 2 }
    assert_equal(stats, @page.authors_statistics)
  end

  def test_best_author
    assert_equal('Author_2', @page.best_author)
  end

  def test_search
    assert_equal([@page.articles[1]], @page.search('ac'))
  end
end
