class AncestorService

  def common_ancestor(a, b)
    node_a = Node.find_by(id: a)
    node_b = Node.find_by(id: b)

    return { root_id: nil, lowest_common_ancestor: nil, depth: nil } if node_a.blank? || node_b.blank?

    ancestors_a = get_ancestors(node_a)
    ancestors_b = get_ancestors(node_b)

    return { root_id: ancestors_a.last, lowest_common_ancestor: a, depth: ancestors_a.count } if a == b

    common_ancestors = []

    ancestors_a.reverse_each do |ancestor_id|
      if ancestors_b.include?(ancestor_id)
        common_ancestors << ancestor_id
      end
    end

    if common_ancestors.present?
      { root_id: ancestors_a.last, lowest_common_ancestor: common_ancestors.last, depth: common_ancestors.count }
    else
      { root_id: nil, lowest_common_ancestor: nil, depth: nil }
    end
  end

  def get_descendant_birds(node_ids)
    descendant_birds_ids = Set.new

    traverse_tree = lambda do |node|
      node.birds.each { |bird| descendant_birds_ids << bird.id }

      node.children.each do |child|
        traverse_tree.call(child)
      end
    end

    node = Node.where(id: node_ids).includes(:birds, children: :birds).first

    traverse_tree.call(node)

    descendant_birds_ids.to_a
  end

  private

  def get_ancestors(node)
    ancestors = [node.id]
    return ancestors if node.parent_id.blank?

    while node.parent_id.present?
      ancestors << node.parent_id
      node = Node.find_by(id: node.parent_id)
    end

    ancestors
  end
end
