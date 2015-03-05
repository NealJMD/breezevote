shared_examples "pdfable" do |model, class_sym|

  let(:doc) { create class_sym }

  subject { doc }

  it { should be_valid }
  it { should respond_to(:render_html)}
  it { should respond_to(:render_pdf)}
  it { should respond_to(:render_filename)}
  it { should respond_to(:save_pdf)}
  it { should respond_to(:save_pdf)}

end