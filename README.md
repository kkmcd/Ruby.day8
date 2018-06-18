# Day8

※ rails g model board contents ip_address는 String 속성까지 만들어냄

※ rails g model board contents:text ip_address index:integer는 타입까지 지정

※ rails g controller tweet index show new edit #컨트롤러 생성시 index, show,new, edit 함수를 같이 생성함



## Twitter 만들기

### routes.rb

```ruby
Rails.application.routes.draw do
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/tweets' => 'tweet#index'
  get '/tweet/new' => 'tweet#new'
  post '/tweet/create' => 'tweet#create'
  get '/tweet/:id/destroy' => 'tweet#destroy'
  get '/tweet/:id/edit' => 'tweet#edit'
  post '/tweet/:id/update' => 'tweet#update'
  get '/tweet/:id' => 'tweet#show'
end
```



### tweet_controller.rb

```ruby
class TweetController < ApplicationController
  def index
    @boards = Board.all
    cookies[:user_name] = "윤영민"
  end

  def show
    @board = Board.find(params[:id])
  end

  def new
  end

  def edit
    @board = Board.find(params[:id])
  end
  
  def create
    board = Board.new
    board.contents = params[:contents]
    board.ip_address = request.ip
    board.save
    flash[:success] = "새 글이 등록되었습니다."
    redirect_to "/tweet/#{board.id}"
  end
  
  def update
    board = Board.find(params[:id])
    board.contents = params[:contents]
    board.ip_address = request.ip
    board.save
    flash[:success] = "수정이 완료되었습니다."
    redirect_to "/tweet/#{board.id}"
  end
  
  def destroy
    board = Board.find(params[:id])
    board.destroy
    flash[:error] = "글이 삭제되었습니다."
    redirect_to '/tweets'
  end
end
```



### model 부분

```ruby
$ rails g model board contents ip_address
```

```ruby
class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.string :contents
      t.string :ip_address

      t.timestamps
    end
  end
end
```



### index.html.erb

```ruby
<div class = "text-center">
<a class = "btn btn-primary" href = "/tweet/new"> 새글 등록하기 </a>
</div>
<div class="list-group">
<% @boards.each do |board| %>
    <%= link_to truncate(board.contents, length:10), "/tweet/#{board.id}", class: "list-group-item list-group-item-action"%>
    <!--<%= board.created_at%>-->
<% end %>

</div>
```



### new.html.erb

```ruby
<!--<form action="/tweet/create" method="POST">-->
<%= form_tag('/tweet/create', remote: true) do %>
<!--    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">-->
    <!--<textarea name="contents"></textarea>-->
    <!--<input type="submit" value="작성하기">-->
    <%=text_area_tag 'contents',  nil,  class: "form-control"%>
    <%= submit_tag "작성하기" , class: "btn btn-primary" %>
<!--</form>--> <!--form tag로 대체-->
<% end%>
```



### edit.html.erb

```ruby
<form action="/tweet/<%= @board.id %>/update" method="POST">
    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
    <textarea name="contents"><%= @board.contents %></textarea>
    <input type="submit" value="작성하기">
</form>
```



### show.html.erb

```ruby
<h2><%= @board.contents %></h2>
<p><%= @board.ip_address %></p>
<a href="/tweets">목록</a>
<a href="/tweet/<%= @board.id %>/edit">수정</a>
<a href="/tweet/<%= @board.id %>/destroy">삭제</a>
```



### Gemfile

```ruby
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

....

gem 'bootstrap', '~> 4.1.1'

gem 'toastr_rails'


```



### twitter_app > app > assets > javascripts > application.js

```ruby
...
//= require popper
//= require bootstrap
//= require toastr_rails
...

toastr.options = {
  "closeButton": true,
  "debug": false,
  "progressBar": true,
  "positionClass": "toast-top-right",
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
};
```



### twitter_app > app > assets > stylesheets > application.scss

```ruby
@import 'bootstrap';
@import 'toastr_rails';

#toast-container{
  top: 70px;
}
```



### form-helper, view helper

- http://guides.rubyonrails.org/form_helpers.html 참고
- form이나 view를 함수처럼 사용해서 사용하기 쉽게 만들어낸 것.
- form_tag는 요청도 자바스크립트로, 응답도 자바스크립트로 받는 방법임
- a태그는 link_to로 바꿔줄 수 있음. 즉,  <%= link_to board.contents, "/tweet/<%= board.id %>">로 변경가능



### flash

- flash는 한 번 보여지고 더 이상 보여주지않는 것을 말함. 

```ruby
  def update
    ...
    flash[:success] = "수정이 완료되었습니다."
    ...
  end
  
  def destroy
	...
    flash[:error] = "글이 삭제되었습니다."
    ...
  end
```

- flash를 사용하면, 어떤 이벤트가 발생했을 때, 일정시간동안 alert를 발생시킴



### Cookie와 Session

- _twitter_app_session이 로그인한 유저의 정보를 갖고 있음. 즉, 브라우저가 들고있다는 말임. 서버가 가지고있는게 아님. 즉, client와 server가 정보를 주고 받을 때, request와 response가 독립적으로 움직이는데, 쿠키는 브라우저에 정보를 주고받은 것을 저장하고, 세션은 해쉬로 암호와하여 비밀리에 주고받는다.
- flash도 하나의 쿠키임.. 휘발성
- https://developer.mozilla.org/ko/docs/Web/HTTP/Cookies
- 쿠키는 상태가 없는([stateless](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview#HTTP_is_stateless_but_not_sessionless)) HTTP 프로토콜에서 상태 기반 정보를 기억합니다.
