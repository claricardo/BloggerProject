class ArticlesController < ApplicationController
	include ArticlesHelper

	before_filter :require_login, except: [:index, :show, :show_popular_articles, :show_by_month, :rss_feed]
	
	def index
		@articles = Article.all
	end
	
	def show
		@article = Article.find(params[:id])
		@article.increment_view_count
		
		@comment = Comment.new
		@comment.article_id = @article_id
	end
	
	def show_popular_articles
		@articles = Article.all.order(view_count: :desc).limit(3)
	end
	
	
	#***************************************************************************
	def show_by_month
		mon = params[:month].to_i
		mon_str = '%02d'%(mon + 1)
		@month = $months[mon]
		
		@adapter_type = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
		case @adapter_type
			when :sqlite
				@articles = Article.where("strftime('%m', created_at) = ?", mon_str)
			when :postgresql
				@articles = Article.where("to_char(created_at, 'MM') = ?", mon_str)
			else
				raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
		end
		
	end
	
	def new
		@article = Article.new
	end
	
	def create
		@article = Article.new(article_params)
		@article.view_count = 0
		@article.author_id = current_user.id
		@article.save
		
		flash.notice = "Article '#{@article.title}' created!"
		redirect_to article_path(@article)
	end
	
	def edit
		@article = Article.find(params[:id])
	end
	
	def update
		@article = Article.find(params[:id])
		@article.update(article_params)
		
		flash.notice = "Article '#{@article.title}' updated!"
		redirect_to article_path(@article)
	end
	
	def destroy
		@article = Article.find(params[:id])
		@article.destroy
		
		flash.notice = "Article '#{@article.title}' deleted!"
		redirect_to articles_path
	end
	
	def rss_feed
		@articles = Article.all.select('title', 'author_id', 'body', 'created_at', 'id').order(created_at: :desc).limit(25)
		
		respond_to do |format|
			format.rss { render :layout => false, :action  => 'rss_feed'}
		end
	end
end
