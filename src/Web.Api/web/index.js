// Fetch and render navigation tree on page load
window.addEventListener('DOMContentLoaded', () => {
  fetch('/api/plot/tree')
    .then(response => response.json())
    .then(tree => {
      console.log('Loaded tree from backend:', tree);
      renderTree(tree);
      // Auto-select first node and render its plan
      if (tree.length > 0) {
        selectZone(tree[0]);
      }
    });
});

let currentZone = null;
let currentTree = null;

function renderTree(tree, parentElement, level = 1) {
  const nav = parentElement || document.getElementById('atlas-tree');
  if (!parentElement) nav.innerHTML = '';
  tree.forEach(node => {
    console.log('Rendering node:', node.name, node.children);
    const nodeDiv = document.createElement('div');
    nodeDiv.className = 'atlas-tree-node';
    nodeDiv.textContent = node.name;
    nodeDiv.onclick = (e) => {
      e.stopPropagation();
      selectZone(node);
    };
    nav.appendChild(nodeDiv);
    // Only render children if we are not past level 3 (ext area, building, floor)
    if (node.children && node.children.length > 0 && level < 3) {
      const childrenDiv = document.createElement('div');
      childrenDiv.className = 'atlas-tree-children';
      renderTree(node.children, childrenDiv, level + 1);
      nav.appendChild(childrenDiv);
    }
  });
}

function selectZone(zone, parent) {
  currentZone = zone;
  renderAddressBar(zone, parent);
  renderPlan(zone.id);
}

function renderAddressBar(zone, parent) {
  const ab = document.getElementById('atlas-addressbar');
  ab.innerHTML = '';
  if (parent) {
    const parentBtn = document.createElement('button');
    parentBtn.className = 'addressbar-btn';
    parentBtn.textContent = parent.name;
    parentBtn.onclick = () => selectZone(parent);
    ab.appendChild(parentBtn);
    const sep = document.createElement('span');
    sep.className = 'addressbar-sep';
    sep.textContent = '→';
    ab.appendChild(sep);
  }
  const zoneBtn = document.createElement('button');
  zoneBtn.className = 'addressbar-btn';
  zoneBtn.textContent = zone.name;
  ab.appendChild(zoneBtn);
}

function renderPlan(zoneId) {
  fetch('/api/plot/plan/' + encodeURIComponent(zoneId))
    .then(response => response.json())
    .then(plan => {
      const container = document.getElementById('container');
      container.innerHTML = '';
      const width = container.offsetWidth || window.innerWidth;
      const height = container.offsetHeight || window.innerHeight;
      const stage = new Konva.Stage({
        container: 'container',
        width: width,
        height: height,
      });
      const layer = new Konva.Layer();
      stage.add(layer);
      const scale = Math.min(width / plan.planWidth, height / plan.planHeight) * 0.8;
      const offsetX = (width - plan.planWidth * scale) / 2;
      const offsetY = (height - plan.planHeight * scale) / 2;
      function m(x) { return x * scale; }
      // Draw all shapes
      plan.shapes.forEach(shape => {
        if (shape.type === 'rect') {
          layer.add(new Konva.Rect({
            x: offsetX + m(shape.x),
            y: offsetY + m(shape.y),
            width: m(shape.w),
            height: m(shape.h),
            fill: shape.fill,
            stroke: shape.stroke,
            strokeWidth: 1.5,
            opacity: 0.8,
          }));
          if (shape.text) {
            layer.add(new Konva.Text({
              x: offsetX + m(shape.x) + m(shape.w) / 2 - 50,
              y: offsetY + m(shape.y) + m(shape.h) / 2 - 12,
              text: shape.text,
              fontSize: 20,
              fontFamily: 'Arial',
              fill: shape.textColor || '#222',
              width: 100,
              align: 'center',
            }));
          }
        } else if (shape.type === 'door') {
          // Draw door as a thin orange rectangle
          layer.add(new Konva.Rect({
            x: offsetX + m(shape.x),
            y: offsetY + m(shape.y),
            width: m(shape.w || 10), // default width if not provided
            height: m(shape.h || 3), // default height if not provided
            fill: shape.fill || 'orange',
            stroke: shape.stroke || 'darkorange',
            strokeWidth: 1.5,
            opacity: 1,
          }));
        } else if (shape.type === 'transit') {
          // Draw transit as a round rectangle with bold green border and empty inside, fixed size
          const width = 40;
          const height = 20;
          layer.add(new Konva.Rect({
            x: offsetX + m(shape.x) - width / 2,
            y: offsetY + m(shape.y) - height / 2,
            width: width,
            height: height,
            cornerRadius: height / 2,
            fill: '', // empty inside
            stroke: 'green',
            strokeWidth: 4,
            opacity: 1,
          }));
        }
        // Add more shape types as needed (circle, line, etc.)
      });
      layer.draw();
    });
} 