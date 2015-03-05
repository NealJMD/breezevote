describe Pdfable do

  # we use the :all syntax here because creating pdfs is time expensive
  # and it slows down our tests.

  before :all do
    acceptable = [:nc_ballot_request, :va_ballot_request]
    @doc = create acceptable.sample
  end
  after :all do
    @doc.destroy
  end

  describe :render_html do

    before :all do
      @markup = @doc.render_html
    end

    it "should be over 1000 characters" do
      expect(@markup.length).to be >= 1000
    end

    it "should be HTML5" do
      expect(@markup).to start_with("<!DOCTYPE html>")
    end
  end

  describe :render_filename do

    it "should only have alphabet characters, numbers, and dashes" do
      expect(@doc.render_filename).to match(/\A[A-Za-z0-9\-]+\z/)
    end

  end

  describe :create_pdf do

    before :all do
      expect { @doc.create_pdf }.to change { PdfAsset.count }.by 1
      @doc.reload
      expect(@doc.pdf_asset).not_to be_blank
    end
    after :all do
      @doc.reload
      expect { @doc.pdf_asset.destroy }.to change { PdfAsset.count }.by -1
    end

    describe :without_existing do

      it "should have its own pdf_asset" do
        expect(@doc.pdf_asset).not_to be_blank
      end

      it "should have an attachment" do
        expect(@doc.pdf_asset.pdf).not_to be_blank
      end

      it "should have a filepath" do
        expect(@doc.pdf_asset.pdf.path).not_to be_blank
      end

      it "should have a file at the filepath" do
        expect(File).to exist("#{Rails.root}/#{@doc.pdf_asset.pdf.path}")
      end
    end

    describe :with_existing do

      before :all do
        @doc.reload
        @id = @doc.pdf_asset.id
        @fullpath = "#{Rails.root}/#{@doc.pdf_asset.pdf.path}"
        @atime = File.atime(@fullpath)
      end

      describe :default do

        it "should return false" do
          expect( @doc.create_pdf ).to eq false
        end

        it "should not change the pdf count" do
          expect{ @doc.create_pdf }.to change{ PdfAsset.count}.by 0
        end

        it "should not touch the existing pdf_asset" do
          expect(PdfAsset.last.id).to eq @id
        end

        it "should not touch the existing pdf file" do
          expect(File.atime(@fullpath)).to eq @atime
        end

      end

      describe :with_overwrite do

        before :all do
          @count = PdfAsset.count
          @doc.create_pdf(:overwrite)
          @doc.reload
        end

        it "should not change the pdf count" do
          expect( PdfAsset.count ).to eq @count
        end

        it "should have a file at the filepath" do
          expect(File).to exist("#{Rails.root}/#{@doc.pdf_asset.pdf.path}")
        end

        it "should overwrite the existing pdf_asset" do
          expect(PdfAsset.last.id).not_to eq @id
        end

        it "should overwrite the existing pdf file" do
          expect(File.atime(@fullpath)).not_to eq @atime
        end
      end
    end
  end
end