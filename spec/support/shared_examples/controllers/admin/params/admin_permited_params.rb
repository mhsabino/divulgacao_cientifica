RSpec.shared_examples "admin_permited_params" do
  it do
    is_expected.to permit(*permitted_params)
      .for(action, params: valid_params).on(model_symbol)
  end
end
