class ProcedureLinesController < ApplicationController
  before_action :set_line, only: [:show, :edit, :update, :destroy]

  add_breadcrumb "Inicio", :root_path
  
  def index
    set_city(:city_id)
    
    add_breadcrumb @city.name ,city_path(@city)
    add_breadcrumb "Tramites", city_procedure_lines_path(@city)

    @procedure = Procedure.all.order('nombre DESC')
    @id_del_giro = "0"
    @tipo  = 'A'
    valores  if params[:get]
    @cities = City.all
  end

  def valores
   @line = params[:get][:lines]
   if valida_giro.nil?
     @tipo = params[:rating]
     @etapa = params[:etapa]
     if valida_categoria.nil?
       @categoria = get_categoria(params[:etapa])
       @tramites_del_giro =  ProcedureLine.where(line_id: @line)
     end
   end
 end

 def show
  set_city(:city_id)
  @cities = City.all
  
  @procedure_requirements = ProcedureRequirement.all
  @procedure_lines=  ProcedureLine.all
  @requirements = Requirement.all
  @line = Line.find(@procedure_line.line_id).name
  @procedure = Procedure.find(@procedure_line.procedure_id).name
  @procedure_requirement = @procedure_requirements.where(procedure_id: Procedure.find(@procedure_line.procedure_id).id)



  add_breadcrumb @city.name, city_path(@city)
  add_breadcrumb "Tramites", city_procedure_lines_path(@city)
  add_breadcrumb @procedure

  
end



def get_categoria(tipo)
  if tipo == 'Crear'
    'Constituye tu empresa'
  elsif tipo == 'Administrar'
    'Administra tu empresa'
  elsif tipo == 'Crecer'
    'Crece y financia tu empresa'
  elsif tipo == 'Construir'
    'Construcción'
  elsif tipo == 'Cerrar'
    'Cierre de giro de tu empresa'
  end
end


def new
  @procedure_line = ProcedureLine.new
  @procedure = Procedure.all
  @Line = Line.all


end

def edit
  @procedure = Procedure.all
  @line = Line.all
end

def create
  @procedure_line = ProcedureLine.new(line_params)
  respond_to do |format|
    if @procedure_line.save
      format.html { redirect_to @procedure_line, notice: 'Line was successfully created.' }
      format.json { render :show, status: :created, location: @procedure_line }
    else
      format.html { render :new }
      format.json { render json: @procedure_line.errors, status: :unprocessable_entity }
    end
  end
end

def update
  respond_to do |format|
    if @procedure_line.update(line_params)
      format.html { redirect_to @procedure_line, notice: 'Line was successfully updated.' }
      format.json { render :show, status: :ok, location: @procedure_line}
    else
      format.html { render :edit }
      format.json { render json: @procedure_line.errors, status: :unprocessable_entity }
    end
  end
end

def valida_giro
  if @line.nil? || @line.empty?
    redirect_to city_procedure_lines_path(@city), error: 'Debes seleccionar un giro.' 
    return "OK"
  end
  return nil
end

def valida_categoria
  if @etapa.nil? || @etapa.empty?
    redirect_to city_procedure_lines_path(@city), error:  'Debes seleccionar una categoría.' 
    return "OK"
  end
  return nil
end



private
    # Use callbacks to share common setup or constraints between actions.
    def set_line
      @procedure_line = ProcedureLine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_params
      params.require(:procedure_line).permit(:id, :procedure_id, :line_id)
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_city(val)
      @city = City.find(params[val])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name)
    end
  end
