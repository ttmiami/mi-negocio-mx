class FormationStepsController < ApplicationController
 layout 'blanco'
 before_action :set_formation_steps, only: [:show]
helper :formation_steps

 def index
  set_municipio(:municipio_id)
  @tipo = 'AF'
  valores  if params[:get]
    @municipios = Municipio.all
    if user_signed_in?
      @tramites_realizados =  UserFormationStep.where(user_id: current_user.id, line_id: @line , tipo: @tipo).all
    end
    
end

def valores
  if params[:get][:lines]
   @line = params[:get][:lines]
   @tipo = params[:rating]
   @id_formation_step = params[:guardado]
      unless @id_formation_step.nil?
        if UserFormationStep.where(user_id: current_user.id, formation_step_id: @id_formation_step , line_id: @line , tipo: @tipo).first.nil?
          a = UserFormationStep.create(user_id: current_user.id, formation_step_id: @id_formation_step, line_id: @line , tipo: @tipo)
          a.save
        end
      end 
   @formation_steps = FormationStep.by_city(@municipio)
   # @heading = view_context.heading_search(Line.find(@line).nombre.downcase)
   # @subheading = view_context.subheading_search(@tipo)
 end
end

def show
end

private
      # Use callbacks to share common setup or constraints between actions.
      def set_municipio(val)
        @municipio = Municipio.find(params[val])
      end

      def set_formation_steps
        @formation_step = FormationStep.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def formation_step_params
        params.require(:formationsteps).permit(:name, :description,:path,:type )
      end
    end
