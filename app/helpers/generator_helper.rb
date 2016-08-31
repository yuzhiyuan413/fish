module GeneratorHelper

  # Fill the partner based on product_tag before save the seed activation records.
  def fill_partners records
    partner_map = {}.tap do |x|
      SmartDs::ProductTag.all.eager_load(:partner).each do |r|
        x[r.tag] = r.partner.try(:name)
      end
    end
    {}.tap do |x|
      records.each do |k,v|
        v[:partner] = partner_map[k[:tag]]
        x[k] = v
      end
    end
  end
end
