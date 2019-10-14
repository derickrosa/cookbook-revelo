module FormHelpers
    def submit_form
        find('button[name="button"]').click
    end
end