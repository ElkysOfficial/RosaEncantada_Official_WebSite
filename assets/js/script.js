/* ====================================================================
   ROSA ENCANTADA BY LORRAINE, Interações premium
   ==================================================================== */

/* ============ CATÁLOGO ============ */
/* Carregado de data/products.json em loadProducts(), ver INIT */
let PRODUCTS = [];

const WHATSAPP_NUMBER = '5531986977393';
const fmt = (n) => n.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });

/* ============ STATE ============ */
const state = {
  cart: JSON.parse(localStorage.getItem('rosa-cart') || '{}'),
  filter: 'all',
};
const persist = () => localStorage.setItem('rosa-cart', JSON.stringify(state.cart));

/* ============ RENDER PRODUTOS ============ */
const productsEl = document.getElementById('products');
function renderProducts() {
  productsEl.innerHTML = PRODUCTS.map(p => `
    <article class="product reveal" data-cat="${p.cat}">
      <div class="product__media">
        ${p.badge ? `<span class="product__badge">${p.badge}</span>` : ''}
        <span aria-hidden="true">${p.emoji}</span>
        ${p.image ? `<img class="product__photo" src="${p.image}" alt="${p.name}" loading="lazy" onerror="this.remove()" />` : ''}
      </div>
      <div class="product__body">
        <span class="product__cat">${categoryLabel(p.cat)}</span>
        <h3 class="product__name">${p.name}</h3>
        <p class="product__desc">${p.desc}</p>
        <div class="product__foot">
          <span class="product__price">${fmt(p.price)}</span>
          <button class="product__add" data-add="${p.id}" aria-label="Adicionar ${p.name} ao carrinho">
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Adicionar
          </button>
        </div>
      </div>
    </article>
  `).join('');
  observeReveals();
}
function categoryLabel(c) {
  return { trufa: 'Trufa Artesanal', caixa: 'Caixa Presente' }[c] || c;
}

/* ============ FILTROS ============ */
document.querySelectorAll('.filter').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.filter').forEach(b => b.classList.remove('is-active'));
    btn.classList.add('is-active');
    state.filter = btn.dataset.filter;
    document.querySelectorAll('.product').forEach((card, i) => {
      const show = state.filter === 'all' || card.dataset.cat === state.filter;
      if (show) {
        card.classList.remove('is-hidden');
        card.style.animation = 'none';
        // forçar reflow para reanimar
        void card.offsetWidth;
        card.style.animation = `hero-rise .55s ${i * 60}ms cubic-bezier(.22,1,.36,1) both`;
      } else {
        card.classList.add('is-hidden');
      }
    });
  });
});

/* ============ CARRINHO ============ */
const cartEl       = document.getElementById('cart');
const cartItemsEl  = document.getElementById('cartItems');
const cartTotalEl  = document.getElementById('cartTotal');
const cartCountEl  = document.getElementById('cartCount');
const cartBtn      = document.getElementById('cartBtn');

let lastFocused = null;
function openCart() {
  lastFocused = document.activeElement;
  cartEl.setAttribute('aria-hidden', 'false');
  document.body.style.overflow = 'hidden';
  setTimeout(() => {
    cartEl.querySelector('.cart__close')?.focus();
  }, 220);
}
function closeCart() {
  cartEl.setAttribute('aria-hidden', 'true');
  document.body.style.overflow = '';
  lastFocused?.focus();
}

cartBtn.addEventListener('click', openCart);
document.querySelectorAll('[data-close-cart]').forEach(el => el.addEventListener('click', closeCart));
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && cartEl.getAttribute('aria-hidden') === 'false') closeCart();
});

document.addEventListener('click', (e) => {
  const addBtn = e.target.closest('[data-add]');
  if (addBtn) {
    const id = addBtn.dataset.add;
    const product = PRODUCTS.find(p => p.id === id);
    addToCart(id);
    pulseCartBtn();
    showToast(`${product.name} adicionado à sua caixinha`);
  }
});

function addToCart(id) {
  state.cart[id] = (state.cart[id] || 0) + 1;
  persist(); renderCart();
}
function changeQty(id, delta) {
  state.cart[id] = (state.cart[id] || 0) + delta;
  if (state.cart[id] <= 0) delete state.cart[id];
  persist(); renderCart();
}
function removeItem(id) { delete state.cart[id]; persist(); renderCart(); }

function renderCart() {
  const ids = Object.keys(state.cart);
  let total = 0, count = 0;

  if (!ids.length) {
    cartItemsEl.innerHTML = `
      <div class="cart-empty">
        <span aria-hidden="true">🍫</span>
        <strong>Sua caixinha está vazia</strong>
        Que tal começar pela Trufa Belga? É a queridinha da casa.
      </div>`;
  } else {
    cartItemsEl.innerHTML = ids.map(id => {
      const p = PRODUCTS.find(x => x.id === id);
      const qty = state.cart[id];
      total += p.price * qty; count += qty;
      return `
        <div class="cart-item">
          <div class="cart-item__media">${p.emoji}</div>
          <div>
            <div class="cart-item__name">${p.name}</div>
            <div class="cart-item__price">${fmt(p.price)} · cada</div>
            <div class="cart-item__qty">
              <button data-qty-minus="${id}" aria-label="Diminuir quantidade">−</button>
              <span>${qty}</span>
              <button data-qty-plus="${id}" aria-label="Aumentar quantidade">+</button>
            </div>
          </div>
          <button class="cart-item__remove" data-remove="${id}" aria-label="Remover ${p.name}">remover</button>
        </div>`;
    }).join('');
  }

  cartTotalEl.textContent = fmt(total);
  cartCountEl.textContent = count;
  cartCountEl.style.display = count ? 'grid' : 'none';
}

cartItemsEl.addEventListener('click', (e) => {
  const minus = e.target.closest('[data-qty-minus]');
  const plus  = e.target.closest('[data-qty-plus]');
  const rem   = e.target.closest('[data-remove]');
  if (minus) changeQty(minus.dataset.qtyMinus, -1);
  if (plus)  changeQty(plus.dataset.qtyPlus, +1);
  if (rem)   removeItem(rem.dataset.remove);
});

function pulseCartBtn() {
  cartBtn.animate(
    [{ transform: 'scale(1)' }, { transform: 'scale(1.22) rotate(-8deg)' }, { transform: 'scale(1)' }],
    { duration: 480, easing: 'cubic-bezier(.22,1,.36,1)' }
  );
  cartCountEl.classList.remove('is-bumped');
  void cartCountEl.offsetWidth;
  cartCountEl.classList.add('is-bumped');
}

/* ============ TOAST ============ */
const toastEl = document.getElementById('toast');
let toastTimer;
function showToast(message) {
  toastEl.textContent = message;
  toastEl.classList.add('is-visible');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toastEl.classList.remove('is-visible'), 2600);
}

/* ============ CHECKOUT VIA WHATSAPP ============ */
document.getElementById('checkoutBtn').addEventListener('click', () => {
  const ids = Object.keys(state.cart);
  if (!ids.length) {
    showToast('Adicione algum item antes de finalizar 🌸');
    return;
  }

  let total = 0;
  const lines = ids.map(id => {
    const p = PRODUCTS.find(x => x.id === id);
    const qty = state.cart[id];
    total += p.price * qty;
    return `• ${qty}x ${p.name}, ${fmt(p.price * qty)}`;
  });

  const msg = encodeURIComponent(
    `Olá, Lorraine! 🌸\n\nGostaria de fazer um pedido na Rosa Encantada:\n\n${lines.join('\n')}\n\n*Total estimado: ${fmt(total)}*\n\nFico no aguardo para combinarmos os detalhes (data de entrega, forma de pagamento e endereço). Obrigado(a)!`
  );
  window.open(`https://wa.me/${WHATSAPP_NUMBER}?text=${msg}`, '_blank');
});

/* ============ CONTATO FORM ============ */
const contactForm = document.getElementById('contactForm');
const formNote    = document.getElementById('formNote');
contactForm.addEventListener('submit', (e) => {
  e.preventDefault();
  const data = Object.fromEntries(new FormData(contactForm).entries());
  if (!data.nome || !data.email || !data.mensagem) {
    formNote.hidden = false;
    formNote.className = 'form__note is-error';
    formNote.textContent = 'Por favor, preencha nome, e-mail e mensagem para continuarmos.';
    return;
  }
  const msg = encodeURIComponent(
    `Olá, Lorraine! 🌸\n\nSou *${data.nome}* (${data.email}).\n*Assunto:* ${data.assunto}\n\n${data.mensagem}`
  );
  window.open(`https://wa.me/${WHATSAPP_NUMBER}?text=${msg}`, '_blank');
  formNote.hidden = false;
  formNote.className = 'form__note is-success';
  formNote.textContent = 'Sua mensagem está pronta no WhatsApp, basta enviar. 🌸';
  contactForm.reset();
  setTimeout(() => { formNote.hidden = true; }, 5000);
});

/* ============ THEME TOGGLE ============ */
const themeToggleBtn = document.getElementById('themeToggle');
if (themeToggleBtn) {
  themeToggleBtn.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme') || 'light';
    const next = current === 'dark' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', next);
    try { localStorage.setItem('rosa-theme', next); } catch (e) {}
  });
}

/* ============ MENU MOBILE ============ */
const menuBtn = document.getElementById('menuBtn');
const navEl   = document.getElementById('nav');
menuBtn.addEventListener('click', () => {
  const open = menuBtn.classList.toggle('is-open');
  navEl.classList.toggle('is-open');
  menuBtn.setAttribute('aria-expanded', open);
});
navEl.addEventListener('click', (e) => {
  if (e.target.matches('.nav__link')) {
    menuBtn.classList.remove('is-open');
    navEl.classList.remove('is-open');
    menuBtn.setAttribute('aria-expanded', 'false');
  }
});

/* ============ HEADER + SCROLL PROGRESS ============ */
const header = document.getElementById('header');
const progressEl = document.getElementById('scrollProgress');
function onScroll() {
  const y = window.scrollY;
  header.classList.toggle('is-scrolled', y > 8);

  const docHeight = document.documentElement.scrollHeight - window.innerHeight;
  const pct = docHeight > 0 ? (y / docHeight) * 100 : 0;
  progressEl.style.width = `${Math.min(100, pct)}%`;
}
window.addEventListener('scroll', onScroll, { passive: true });

/* ============ SCROLL-SPY (link ativo no header) ============ */
const navLinks = document.querySelectorAll('.nav__link');
const sections = ['hero', 'produtos', 'encomendas', 'contato']
  .map(id => document.getElementById(id))
  .filter(Boolean);

const spyObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const id = entry.target.id;
      navLinks.forEach(l => {
        l.classList.toggle('is-active', l.getAttribute('href') === `#${id}`);
      });
    }
  });
}, { rootMargin: '-40% 0px -55% 0px', threshold: 0 });
sections.forEach(s => spyObserver.observe(s));

/* ============ REVEAL ON SCROLL ============ */
let revealObserver;
function observeReveals() {
  if (!revealObserver) {
    revealObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          revealObserver.unobserve(entry.target);
        }
      });
    }, { threshold: .12, rootMargin: '0px 0px -60px 0px' });
  }
  document.querySelectorAll('.reveal:not(.is-visible)').forEach(el => revealObserver.observe(el));
}

document.querySelectorAll(
  '.section, .feature, .testimonial, .encomendas__card, .step, .floating-card'
).forEach(el => el.classList.add('reveal'));

document.querySelectorAll('.features, .testimonials, .steps, .encomendas__media')
  .forEach(el => el.classList.add('reveal--stagger'));

/* ============ PARALLAX SUTIL NO HERO ============ */
const heroImage = document.getElementById('heroImage');
if (heroImage && window.matchMedia('(min-width: 960px) and (hover: hover)').matches) {
  const frame = heroImage.querySelector('.hero__image-frame');
  const cards = heroImage.querySelectorAll('.floating-card');
  let raf;
  heroImage.addEventListener('mousemove', (e) => {
    const rect = heroImage.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    cancelAnimationFrame(raf);
    raf = requestAnimationFrame(() => {
      if (frame) frame.style.transform = `translate(${x * 16}px, ${y * 16}px)`;
      cards.forEach((c, i) => {
        const depth = (i + 1) * 8;
        c.style.transform = `translate(${x * depth}px, ${y * depth}px)`;
      });
    });
  });
  heroImage.addEventListener('mouseleave', () => {
    if (frame) frame.style.transform = '';
    cards.forEach(c => { c.style.transform = ''; });
  });
}

/* ============ MAGNETIC BUTTONS (sutil) ============ */
if (window.matchMedia('(hover: hover)').matches) {
  document.querySelectorAll('.btn--primary, .btn--ghost').forEach(btn => {
    btn.addEventListener('mousemove', (e) => {
      const rect = btn.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;
      btn.style.transform = `translate(${x * 0.15}px, ${y * 0.2}px)`;
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.transform = '';
    });
  });
}

/* ============ JSON-LD DINÂMICO PARA PRODUTOS ============ */
function injectProductSchema() {
  const itemList = {
    "@context": "https://schema.org",
    "@type": "ItemList",
    "name": "Catálogo Rosa Encantada, Trufas e Bombons Artesanais",
    "description": "Trufas, bombons e caixas presente feitos à mão com chocolate belga.",
    "numberOfItems": PRODUCTS.length,
    "itemListElement": PRODUCTS.map((p, i) => ({
      "@type": "ListItem",
      "position": i + 1,
      "item": {
        "@type": "Product",
        "@id": `https://green-hippopotamus-490496.hostingersite.com/#produto-${p.id}`,
        "name": p.name,
        "description": p.desc,
        "category": categoryLabel(p.cat),
        "brand": {
          "@type": "Brand",
          "name": "Rosa Encantada by Lorraine"
        },
        "image": "https://green-hippopotamus-490496.hostingersite.com/assets/social/og-image.jpg",
        "offers": {
          "@type": "Offer",
          "price": p.price.toFixed(2),
          "priceCurrency": "BRL",
          "availability": "https://schema.org/InStock",
          "url": "https://green-hippopotamus-490496.hostingersite.com/#produtos",
          "seller": {
            "@type": "Organization",
            "name": "Rosa Encantada by Lorraine"
          },
          "priceValidUntil": `${new Date().getFullYear() + 1}-12-31`
        },
        "aggregateRating": {
          "@type": "AggregateRating",
          "ratingValue": "5.0",
          "reviewCount": "27",
          "bestRating": "5"
        }
      }
    }))
  };
  const script = document.createElement('script');
  script.type = 'application/ld+json';
  script.textContent = JSON.stringify(itemList);
  document.head.appendChild(script);
}

/* ============ INIT ============ */
document.getElementById('year').textContent = new Date().getFullYear();

async function loadProducts() {
  try {
    const res = await fetch('data/products.json', { cache: 'no-cache' });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    PRODUCTS = await res.json();
  } catch (err) {
    console.error('[Rosa Encantada] Falha ao carregar catálogo:', err);
    PRODUCTS = [];
  }
  renderProducts();
  renderCart();
  observeReveals();
  injectProductSchema();
}
loadProducts();

/* Loader fade-out */
window.addEventListener('load', () => {
  setTimeout(() => {
    document.body.classList.remove('is-loading');
    document.body.classList.add('is-loaded');
  }, 350);
});
// Fallback caso load demore
setTimeout(() => {
  document.body.classList.remove('is-loading');
  document.body.classList.add('is-loaded');
}, 2200);
