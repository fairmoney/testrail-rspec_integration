module Testrail
  module Api
    Configuration = Struct.new(
      :project_url,
      :project_id,
      :suite_id,
      :run_name,
      :username,
      :password,
      :allow,
      keyword_init: true
    )
  end
end
