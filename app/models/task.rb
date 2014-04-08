class Task < ActiveRecord::Base
  sync :all

  default_scope -> { order(created_at: :desc) }

end
