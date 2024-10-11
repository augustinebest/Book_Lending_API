class BooksController < ApplicationController
  before_action :authorize_request, only: [:index, :create, :show, :update, :destroy]

  def index
    books = Book.all
    render json: { data: books }
  end

  def create
    begin
      book = Book.find_by(title: params[:book][:title])

      if book
        render json: { error: "This book already exists!" }, status: :unprocessable_entity
        return
      else
        new_book = Book.new(book_params)
        if new_book.save
          render json: { message: "Book Added successfully!" }, status: :created
        else
          render json: { error: new_book.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      Rails.logger.error "An error ocurred while creating a book #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def show
    begin
      book = Book.find(params[:id])
      render json: { data: book }, status: :ok
    rescue StandardError => e
      Rails.logger.error "An error ocurred while creating a book #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def update
    begin
      book = Book.find(params[:id])
      if book.update(book_params)
        render json: { message: "Book updated successfully!" }, status: :ok
      else
        render json: { error: book.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Book not found" }, status: :not_found
    rescue StandardError => e
      Rails.logger.error "An error ocurred while creating a book #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def destroy
    begin
      book = Book.find(params[:id])
      if book
        book.destroy
        render json: { message: "Book deleted successfully!" }, status: :ok
      else
        render json: { error: book.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Book not found" }, status: :not_found
    rescue StandardError => e
      Rails.logger.error "An error ocurred while creating a book #{e.message}"
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author)
  end
end
