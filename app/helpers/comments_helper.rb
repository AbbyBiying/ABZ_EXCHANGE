module CommentsHelper
  def link_usernames(text)
    text.gsub(/@\w+/) do |username|
      link_to username, user_path(username.sub("@", ""))
    end.html_safe
  end

  def link_hashtags(text)
    text.gsub(/#\w+/) do |hashtag|
      link_to hashtag, search_path(search: hashtag)
    end.html_safe
  end

  def comment_user_is_current_user(comment)
    comment.user == current_user
  end
end
