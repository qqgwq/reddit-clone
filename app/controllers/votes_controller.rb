class VotesController < ApplicationController
  def create
    post_id = params[:post_id]
    vote = Vote.new
    vote.post_id = params[:post_id]
    vote.upvote = params[:upvote]
    vote.account_id = current_account.id
    #check if vote by this user exists
    existing_vote = Vote.where(account_id: current_account.id, post_id: post_id)
    @new_vote = existing_vote.size < 1
    
    respond_to do |format|
      format.js {
        if existing_vote.size > 0
          #destroy existing vate
          existing_vote.first.destroy
        else
          #save new vote
          if vote.save
            @success = true
          else
            @success = false
          end
          @post = Post.find(post_id)
          @total_upvotes = @post.upvotes
          @total_downvotes = @post.downvotes
        end

        @post = Post.find(post_id)
        @is_upvote = params[:upvote]
        
        @current_account = current_account
        render "votes/create"
      }
    end
  end


  private

  def vote_params
    params.require(:vote).permit(:upvote, :post_id)
  end
end