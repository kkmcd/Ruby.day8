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
