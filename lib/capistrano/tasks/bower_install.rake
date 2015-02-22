namespace :deploy do
  desc "Install asset dependencies"
  task :install_assets do
    on roles(:all) do
      within release_path do
        execute :bower, :install, "--no-color"
      end
    end
  end

  before :compile_assets, :install_assets
end
