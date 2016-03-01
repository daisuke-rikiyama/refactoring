class RankingCell < Cell::ViewModel
  def show(args)
    @type = args[:type]
    if @type == "haves"
      @item_ids = Have.group(:item_id).order('count_item_id desc').limit(10).count('item_id').keys
      @items = Item.find(@item_ids).sort_by{|o| @item_ids.index(o.id)}
    else
      @item_ids = Want.group(:item_id).order('count_item_id desc').limit(10).count('item_id').keys
      @items = Item.find(@item_ids).sort_by{|o| @item_ids.index(o.id)}
    end
    render
  end

end
