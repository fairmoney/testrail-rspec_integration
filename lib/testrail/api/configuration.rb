module Testrail
  module Api
    Configuration = Struct.new(
      :project_url,
      :project_id,
      :suite_id,
      :run_name,
      :username,
      :password,
      :upload_results,
      keyword_init: true
    )
  end
end
