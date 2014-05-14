class UploadsController < ApplicationController
  before_filter :authenticate_user!

  def index
    uploads = Upload.all
    response = {files: []}
    uploads.each do |upload|
      response[:files] << {id: upload.id,
                           name: upload.original_filename,
                           #type: file.content_type, # TODO: we should save the extension eg png, docx
                           size: upload.filesize,
                           url:  "http://0.0.0.0:3000#{upload.url}",
                           thumbnailUrl: "http://0.0.0.0:3000#{upload.url}",
                           deleteUrl: "http://0.0.0.0:3000/posts/#{params[:post_id]}/uploads/#{upload.id}",
                           deleteType: 'DELETE'}
    end
    render json: response
  end

  def create
    file = params[:file] || params[:files].first
    filesize = File.size(file.tempfile)

    # compute the sha
    sha1 = Digest::SHA1.file(file.tempfile).hexdigest
    # check if the file has already been uploaded
    upload = Upload.where(sha1: sha1).first
    unless upload
      upload = Upload.create!(
          sha1: sha1,
          original_filename: file.original_filename,
          filesize: filesize,
          url: "",
          width: nil,
          height: nil,
          uploaded_by: current_user
          #uploadable_id: params[:post_id], #todo
          #uploadable_type: 'Post' # should be dynamic
      )
      url = store_upload(file, upload)
      if url.present?
        upload.url = url
        upload.save
      else
        Rails.logger.error("Failed to store upload ##{upload.id} for user ...")
      end
    end
    response = { files: [{ id: upload.id,
                           name: file.original_filename,
                           type: file.content_type,
                           size: filesize,
                           url:  "http://0.0.0.0:3000#{upload.url}",
                           thumbnailUrl: "http://0.0.0.0:3000#{upload.url}",
                           deleteUrl: "http://0.0.0.0:3000/posts/#{params[:post_id]}/uploads/#{upload.id}",
                           deleteType: 'DELETE'}]}
    # just for images thumbnailUrl: "http://0.0.0.0:3000/#{upload.url}"
    render json: response
  end

  def show
    upload = Upload.where(id: params[:upload_id]).first
    render json: upload
  end

  private
    def store_upload(file, upload)
      path = get_path_for_upload(file, upload)
      store_file(file, path)
    end

    def get_path_for_upload(file, upload)
      unique_sha1 = Digest::SHA1.hexdigest("#{Time.now.to_s}#{file.original_filename}")[0..15]
      extension = File.extname(file.original_filename)
      clean_name = "#{unique_sha1}#{extension}"
      # path
      "#{relative_base_url}/#{upload.id}/#{clean_name}"
    end

    def relative_base_url
      "/uploads"
    end

    def public_dir
      "#{Rails.root}/public"
    end

    def store_file(file, path)
      # copy the file to the right location
      copy_file(file, "#{public_dir}#{path}")
      path
      # url
      # "#{Discourse.base_uri}#{path}"
    end

    def copy_file(file, path)
      FileUtils.mkdir_p(Pathname.new(path).dirname)
      # move the file to the right location
      # not using mv, cause permissions are no good on move
      File.open(path, "wb") { |f| f.write(file.read) }
    end
end