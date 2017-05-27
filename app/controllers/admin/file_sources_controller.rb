class Admin::FileSourcesController < Admin::BaseController
  before_action :set_source, only: [:show, :edit, :update, :destroy]

  def index
    query = params[:query]
    @sources = FileSource.latest
    @sources = @sources.where("file_name LIKE '%#{query}%'") if query.present?
    @sources = @sources.paginate(:page => params[:page])
  end

  def new
    @source = FileSource.new
  end

  def edit
  end

  def create
    @source = FileSource.save_file(params[:file_source][:local_file])
    if @source
      flash[:success] = '文件样品创建成功！'
      redirect_to admin_file_sources_path
    else
      flash[:warn] = '请完善填写表单内容'
      render :new
    end
  end

  def update
    if @source.update_attributes(file_source_params)
      flash[:notice] = '文件样品更新成功！'
      redirect_to admin_file_sources_path
    else
      flash[:warn] = '请完善填写表单内容'
      render :edit
    end
  end

  def destroy
    @source.clean
    @source.destroy
    flash[:notice] = '文件样品删除成功'
    redirect_to :back
  end

  private
    def set_source
      @source = FileSource.find(params[:id])
    end

    def file_source_params
      params.require(:file_source).permit(:file_name, :file_type, :file_size, :file_md5, :file_path)
    end
end
