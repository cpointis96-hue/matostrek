import React from 'react';
import ReactDOM from 'react-dom/client';

const gearFamilies = [
  {
    id: 'zpacks',
    name: 'Zpacks',
    category: 'Tentes ultralégères',
    subtitle: 'Templates de fiche pour les modèles à comparer en détail.',
    accent: 'var(--zpacks-accent)',
    surface: 'var(--zpacks-surface)',
    products: [
      {
        name: 'Zpacks Plex Solo',
        price: 'À partir de 699 €',
        imageLabel: 'Image principale',
        images: ['Face avant', 'Profil', 'Intérieur'],
        specs: [
          ['Poids', 'Donnée officielle'],
          ['Structure', 'Donnée officielle'],
          ['Saison', 'Donnée officielle'],
          ['Matière', 'Donnée officielle'],
        ],
        pros: ['Données brutes', 'Vue rapide', 'Images larges'],
        cons: ['Champ officiel manquant'],
      },
      {
        name: 'Zpacks Duplex',
        price: 'À partir de 799 €',
        imageLabel: 'Image principale',
        images: ['Vue large', 'Entrée', 'Détails'],
        specs: [
          ['Poids', 'Donnée officielle'],
          ['Structure', 'Donnée officielle'],
          ['Saison', 'Donnée officielle'],
          ['Matière', 'Donnée officielle'],
        ],
        pros: ['Comparaison directe', 'Lecture instantanée'],
        cons: ['Images à fournir'],
      },
    ],
  },
  {
    id: 'bigagnes',
    name: 'Big Agnes',
    category: 'Tentes et couches de sol',
    subtitle: 'Cartes compactes pour naviguer entre variantes et usages.',
    accent: 'var(--bigagnes-accent)',
    surface: 'var(--bigagnes-surface)',
    products: [
      {
        name: 'Copper Spur HV UL2',
        price: 'À partir de 549 €',
        imageLabel: 'Image principale',
        images: ['Extérieur', 'Abside', 'Plan'],
        specs: [
          ['Poids', 'Donnée officielle'],
          ['Structure', 'Donnée officielle'],
          ['Saison', 'Donnée officielle'],
          ['Matière', 'Donnée officielle'],
        ],
        pros: ['Fiches claires', 'Prix indicatif'],
        cons: ['Galerie en attente'],
      },
      {
        name: 'Tiger Wall UL2',
        price: 'À partir de 499 €',
        imageLabel: 'Image principale',
        images: ['Profil', 'Intérieur', 'Assemblage'],
        specs: [
          ['Poids', 'Donnée officielle'],
          ['Structure', 'Donnée officielle'],
          ['Saison', 'Donnée officielle'],
          ['Matière', 'Donnée officielle'],
        ],
        pros: ['Très lisible', 'Comparaison rapide'],
        cons: ['Données source à compléter'],
      },
    ],
  },
  {
    id: 'cumulus',
    name: 'Cumulus',
    category: 'Duvets techniques',
    subtitle: 'Fiches dédiées aux sacs de couchage, sans superflu.',
    accent: 'var(--cumulus-accent)',
    surface: 'var(--cumulus-surface)',
    products: [
      {
        name: 'Panyam 450',
        price: 'À partir de 449 €',
        imageLabel: 'Image principale',
        images: ['Vue pliée', 'Ouvert', 'Capuche'],
        specs: [
          ['Poids', 'Donnée officielle'],
          ['Température', 'Donnée officielle'],
          ['Garnissage', 'Donnée officielle'],
          ['Coupe', 'Donnée officielle'],
        ],
        pros: ['Lisibilité Apple-style', 'Place pour vos images'],
        cons: ['Données officielles uniquement'],
      },
      {
        name: 'Teneqa 700',
        price: 'À partir de 579 €',
        imageLabel: 'Image principale',
        images: ['Détail zip', 'Volume', 'Capuchon'],
        specs: [
          ['Poids', 'Donnée officielle'],
          ['Température', 'Donnée officielle'],
          ['Garnissage', 'Donnée officielle'],
          ['Coupe', 'Donnée officielle'],
        ],
        pros: ['Comparaison compacte', 'Structure propre'],
        cons: ['Galerie à compléter'],
      },
    ],
  },
];

function App() {
  return (
    <div className="page-shell">
      <style>{styles}</style>
      <header className="topbar">
        <div>
          <div className="brand">Big Four Atlas</div>
          <div className="eyebrow">Base de comparaison ultralégère</div>
        </div>
        <nav className="navchips" aria-label="Sections">
          <button type="button">Zpacks</button>
          <button type="button">Big Agnes</button>
          <button type="button">Cumulus</button>
        </nav>
      </header>

      <main>
        <section className="hero card">
          <div className="hero-copy">
            <p className="kicker">100% données officielles brutes</p>
            <h1>Le site le plus clair pour comparer le Big Four ultraléger.</h1>
            <p className="lede">
              Une interface pensée pour lire vite, comparer juste, et garder la place
              pour vos images produit en grand format.
            </p>
            <div className="hero-points">
              <span>Prix indicatifs en euros</span>
              <span>Aucun panier</span>
              <span>Pas d’extrapolation</span>
            </div>
          </div>
          <div className="hero-grid" aria-label="Points forts">
            <article>
              <strong>Ultra compact</strong>
              <span>Chaque pixel sert la comparaison.</span>
            </article>
            <article>
              <strong>Lecture immédiate</strong>
              <span>Specs, avantages, limites et galerie.</span>
            </article>
            <article>
              <strong>Univers cohérent</strong>
              <span>Tentes, sacs et matelas dans le même langage.</span>
            </article>
          </div>
        </section>

        {gearFamilies.map((family) => (
          <section id={family.id} key={family.id} className="family-block">
            <div className="family-head" style={{ borderColor: family.accent }}>
              <div>
                <p className="family-kicker">{family.category}</p>
                <h2>{family.name}</h2>
                <p>{family.subtitle}</p>
              </div>
              <div className="family-chip" style={{ background: family.accent }}>
                Templates prêts pour données brutes
              </div>
            </div>

            <div className="product-grid">
              {family.products.map((product) => (
                <article className="product-card" key={product.name} style={{ background: family.surface }}>
                  <div className="image-panel">
                    <div className="main-image">
                      <span>{product.imageLabel}</span>
                      <strong>{product.name}</strong>
                    </div>
                    <div className="thumb-row" aria-label="Galerie d’images">
                      {product.images.map((img) => (
                        <button key={img} type="button" className="thumb">
                          {img}
                        </button>
                      ))}
                    </div>
                  </div>

                  <div className="product-copy">
                    <div className="product-meta">
                      <h3>{product.name}</h3>
                      <span>{product.price}</span>
                    </div>
                    <table>
                      <tbody>
                        {product.specs.map(([label, value]) => (
                          <tr key={label}>
                            <th scope="row">{label}</th>
                            <td>{value}</td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                    <div className="split-notes">
                      <div>
                        <h4>Avantages</h4>
                        <ul>
                          {product.pros.map((item) => <li key={item}>{item}</li>)}
                        </ul>
                      </div>
                      <div>
                        <h4>Limites</h4>
                        <ul>
                          {product.cons.map((item) => <li key={item}>{item}</li>)}
                        </ul>
                      </div>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          </section>
        ))}
      </main>
    </div>
  );
}

const styles = `
  :root {
    --bg: #f5f2ed;
    --surface: rgba(255, 255, 255, 0.76);
    --surface-strong: #ffffff;
    --text: #111318;
    --muted: #5f6674;
    --border: rgba(17, 19, 24, 0.1);
    --shadow: 0 24px 70px rgba(17, 19, 24, 0.08);
    --radius: 28px;
    --zpacks-accent: #c64f38;
    --zpacks-surface: linear-gradient(180deg, rgba(198, 79, 56, 0.08), rgba(255,255,255,0.92));
    --bigagnes-accent: #3c6f62;
    --bigagnes-surface: linear-gradient(180deg, rgba(60, 111, 98, 0.08), rgba(255,255,255,0.92));
    --cumulus-accent: #4857b8;
    --cumulus-surface: linear-gradient(180deg, rgba(72, 87, 184, 0.08), rgba(255,255,255,0.92));
  }
  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; }
  body {
    margin: 0;
    background: radial-gradient(circle at top, #fff 0%, var(--bg) 45%, #efe8df 100%);
    color: var(--text);
    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', system-ui, sans-serif;
  }
  a, button { font: inherit; }
  .page-shell {
    max-width: 1440px;
    margin: 0 auto;
    padding: 24px;
  }
  .topbar, .hero, .family-head, .product-card, .main-image, .thumb, table, .hero-grid article {
    backdrop-filter: blur(18px);
  }
  .topbar {
    display: flex;
    justify-content: space-between;
    gap: 16px;
    align-items: center;
    margin-bottom: 22px;
  }
  .brand { font-weight: 700; letter-spacing: -0.03em; font-size: 1.1rem; }
  .eyebrow, .kicker, .family-kicker { color: var(--muted); font-size: 0.85rem; }
  .navchips { display: flex; gap: 10px; flex-wrap: wrap; }
  .navchips a, .navchips button, .thumb {
    border: 1px solid var(--border);
    border-radius: 999px;
    background: rgba(255,255,255,0.72);
    color: var(--text);
    text-decoration: none;
    padding: 0.8rem 1rem;
    min-height: 44px;
  }
  .card, .product-card, .family-head, .hero-grid article {
    border: 1px solid var(--border);
    border-radius: var(--radius);
    background: var(--surface);
    box-shadow: var(--shadow);
  }
  .hero {
    padding: clamp(20px, 3vw, 34px);
    display: grid;
    gap: 20px;
    grid-template-columns: 1.3fr 0.9fr;
    margin-bottom: 28px;
  }
  h1, h2, h3, h4, p { margin: 0; }
  h1 { font-size: clamp(2.2rem, 5vw, 4.6rem); line-height: 0.95; letter-spacing: -0.05em; max-width: 11ch; }
  .lede { margin-top: 16px; color: var(--muted); max-width: 58ch; font-size: 1.08rem; line-height: 1.6; }
  .hero-points { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 18px; color: var(--muted); }
  .hero-points span { padding: 0.7rem 0.95rem; border-radius: 999px; background: rgba(17,19,24,0.04); }
  .hero-grid { display: grid; grid-template-columns: 1fr; gap: 12px; align-content: end; }
  .hero-grid article { padding: 18px; background: rgba(255,255,255,0.68); }
  .hero-grid strong, .family-chip { display: block; }
  .hero-grid span, .family-head p, .product-meta span, td, li { color: var(--muted); }
  .family-block { margin-bottom: 24px; }
  .family-block > .family-head { scroll-margin-top: 24px; }
  .family-head { padding: 18px 20px; display: flex; align-items: center; justify-content: space-between; gap: 16px; border-left: 5px solid; margin-bottom: 14px; }
  .family-head h2 { font-size: clamp(1.5rem, 2vw, 2.2rem); letter-spacing: -0.04em; margin-top: 4px; }
  .family-chip { color: white; padding: 0.8rem 1rem; border-radius: 999px; font-size: 0.92rem; font-weight: 600; }
  .product-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
  .product-card { padding: 14px; display: grid; gap: 14px; }
  .image-panel { display: grid; gap: 10px; }
  .main-image {
    min-height: 320px;
    border-radius: 24px;
    padding: 20px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    background: linear-gradient(135deg, rgba(17,19,24,0.06), rgba(255,255,255,0.88));
    border: 1px solid var(--border);
  }
  .main-image span { color: var(--muted); font-size: 0.9rem; }
  .main-image strong { font-size: clamp(1.2rem, 2vw, 1.8rem); max-width: 10ch; line-height: 1; }
  .thumb-row { display: flex; gap: 10px; overflow-x: auto; padding-bottom: 4px; }
  .thumb { white-space: nowrap; cursor: pointer; }
  .product-copy { padding: 4px 6px 8px; }
  .product-meta { display: flex; justify-content: space-between; gap: 12px; align-items: baseline; margin-bottom: 14px; }
  .product-meta h3 { font-size: 1.2rem; letter-spacing: -0.03em; }
  table { width: 100%; border-collapse: collapse; margin-bottom: 14px; background: rgba(255,255,255,0.52); border-radius: 18px; overflow: hidden; }
  th, td { text-align: left; padding: 0.95rem 1rem; border-bottom: 1px solid rgba(17,19,24,0.08); font-size: 0.95rem; }
  th { color: var(--text); font-weight: 600; width: 42%; }
  .split-notes { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
  .split-notes h4 { font-size: 0.9rem; margin-bottom: 8px; }
  ul { margin: 0; padding-left: 1.1rem; display: grid; gap: 6px; }
  .navchips a:focus-visible, .navchips button:focus-visible, .thumb:focus-visible { outline: 3px solid rgba(72,87,184,0.35); outline-offset: 2px; }
  @media (max-width: 1024px) {
    .hero, .product-grid { grid-template-columns: 1fr; }
  }
  @media (max-width: 640px) {
    .page-shell { padding: 14px; }
    .topbar, .family-head, .product-meta, .split-notes { grid-template-columns: 1fr; flex-direction: column; align-items: flex-start; }
    .navchips { width: 100%; }
    .navchips a { flex: 1; text-align: center; }
    .main-image { min-height: 240px; }
  }
`;

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
