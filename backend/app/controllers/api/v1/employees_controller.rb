class Api::V1::EmployeesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_employee, only: [:show, :update, :destroy]
  
    # GET /api/v1/employees
    def index
      @employees = Employee.all
      render json: @employees
    end
  
    # GET /api/v1/employees/:id
    def show
      render json: @employee
    end
  
    # POST /api/v1/employees
    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        render json: { message: "ADDED", data: @employee }, status: :created
      else
        render json: { message: "FAILED", errors: @employee.errors }, status: :unprocessable_entity
      end
    end
  
    # PUT/PATCH /api/v1/employees/:id
    def update
      if @employee.update(employee_params)
        render json: @employee
      else
        render json: @employee.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /api/v1/employees/:id
    def destroy
      @employee.destroy
      head :no_content
    end
  
    private
  
    def set_employee
      @employee = Employee.find(params[:id])
    end
  
    def employee_params
      params.require(:employee).permit(:name, :role, :gender)
    end
  end
  