defmodule BlogApp.ArticlesTest do
  use BlogApp.DataCase

  alias BlogApp.Articles

  describe "articles" do
    alias BlogApp.Articles.Article

    import BlogApp.ArticlesFixtures

    @invalid_attrs %{status: nil, title: nil, body: nil, submit_date: nil}

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Articles.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Articles.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      valid_attrs = %{
        status: 42,
        title: "some title",
        body: "some body",
        submit_date: ~D[2024-07-23]
      }

      assert {:ok, %Article{} = article} = Articles.create_article(valid_attrs)
      assert article.status == 42
      assert article.title == "some title"
      assert article.body == "some body"
      assert article.submit_date == ~D[2024-07-23]
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()

      update_attrs = %{
        status: 43,
        title: "some updated title",
        body: "some updated body",
        submit_date: ~D[2024-07-24]
      }

      assert {:ok, %Article{} = article} = Articles.update_article(article, update_attrs)
      assert article.status == 43
      assert article.title == "some updated title"
      assert article.body == "some updated body"
      assert article.submit_date == ~D[2024-07-24]
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_article(article, @invalid_attrs)
      assert article == Articles.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Articles.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Articles.change_article(article)
    end
  end
end
