import numpy as np
import pandas as pd

from umap import UMAP
from sklearn import svm
from sklearn.inspection import DecisionBoundaryDisplay

import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

def normalize(samples):
    min_val = np.min(samples)
    max_val = np.max(samples)

    return (samples-min_val)/(max_val-min_val)

def draw_svm_supp(scz_input, scz_embedded):
    _, axes = plt.subplots(3, 6,figsize=(15, 7.5))
    sx_list = ['Auditory Hallucination', 'Visual Hallucination', 'Obsession & Compulsion', 
           'Phobia', 'Erotic Delusion', 'Delusion of being controlled', 'Paranoid Delusion', 
           'Delusion of Reference', 'Delusion of Guilt', 'Grandiose Delusion', 
           'Religious Delusion', 'Thought Broadcasting', 'Thought Insertion', 'Disorganized Behavior',
           'Thought form disorder', 'Avolition', 'Mutism', 'Anhedonia']
    
    for i in range(18):
        core_sx_scz = scz_input[:, i]
        clf1 = svm.SVC(kernel='linear', C=1000)
        clf1.fit(scz_embedded, core_sx_scz)

        new_colors_scz = []
        for sample in range(len(core_sx_scz)):
            if core_sx_scz[sample]:
                new_colors_scz.append("#ef0107")
            else:
                new_colors_scz.append("#023474")

        x = i % 3
        y = i // 3
        ax1 = axes[x][y]
        sc1 = ax1.scatter(scz_embedded[:, 0], scz_embedded[:, 1], c=new_colors_scz)
        ax1.set_title('{}'.format(sx_list[i]), size=10.5)
        ax1.set_xticklabels('')
        ax1.set_xticks([])
        ax1.set_yticklabels('')
        ax1.set_yticks([])

        DecisionBoundaryDisplay.from_estimator(
            clf1,
            scz_embedded,
            plot_method="contour",
            colors="k",
            levels=[-1, 0, 1],
            alpha=0.5,
            linestyles=["--", "-", "--"],
            ax=ax1,
        )
    plt.savefig('results/scz_supplementary.svg', format='svg', dpi=1200)

    return None

def manifold_scz(scz_embedded, num_sx_scz):
    fig, ax = plt.subplots(1, 1, figsize=(3.5, 3.5))
    sc = ax.scatter(scz_embedded[:, 0], scz_embedded[:, 1], c=num_sx_scz, cmap= plt.cm.rainbow)
    ax.set_xticklabels('')
    ax.set_xticks([])
    ax.set_yticklabels('')
    ax.set_yticks([])
    ax.spines[['right', 'top']].set_visible(False)

    fig.subplots_adjust(right=0.85)
    cbar_ax = fig.add_axes([0.88, 0.12, 0.025, 0.25])
    fig.colorbar(sc, cax=cbar_ax)

    plt.savefig('results/fig1a.svg', format='svg', dpi=1200)

    return None

def manifold_core_sx(scz_input, scz_embedded):
    # 15, 16, 17
    num_sx_scz = normalize(np.sum(scz_input[:, [15, 16, 17]], axis=1))

    fig,axes = plt.subplots(1, 1,figsize=(3.5, 3.5))
    ax = axes
    cmap = ListedColormap(["#fdc500", "#ffe487", "#a6d5ff", "#00509d"])
    sc = ax.scatter(scz_embedded[:, 0], scz_embedded[:, 1], c=num_sx_scz, cmap= cmap)
    ax.set_xticklabels('')
    ax.set_xticks([])
    ax.set_yticklabels('')
    ax.set_yticks([])
    ax.spines[['right', 'top']].set_visible(False)

    fig.subplots_adjust(right=0.85)
    cbar_ax = fig.add_axes([0.88, 0.12, 0.025, 0.25])
    cax = plt.colorbar(sc, cmap=cmap, cax=cbar_ax, ticks=np.array([0.125, 0.375, 0.625, 0.875]))
    cax.ax.set_yticklabels(['0', '1', '2', '3'])

    plt.savefig('results/fig1b.svg', format='svg', dpi=1200)

    return None

def draw_svm(scz_input, scz_embedded):
    fig, axes = plt.subplots(1, 3,figsize=(7.5, 2.5))

    sx_list = ['ah', 'vh', 'oc', 'pho', 'ero', 'doc', 'par', 'rfr', 'glt',
     'grn', 'rlg', 'brd', 'ins', 'dsr', 'frm', 'avl', 'mut', 'anh']
    count = 0
    for i in range(18):
        if sx_list[i] in ['anh', 'mut', 'avl']:
            core_sx_scz = scz_input[:, i]
            clf1 = svm.SVC(kernel='linear', C=1000)
            clf1.fit(scz_embedded, core_sx_scz)

            new_colors_scz = []
            for sample in range(len(core_sx_scz)):
                if core_sx_scz[sample]:
                    new_colors_scz.append("#ef0107")
                else:
                    new_colors_scz.append("#023474")

            ax1 = axes[count]
            count += 1
            sc1 = ax1.scatter(scz_embedded[:, 0], scz_embedded[:, 1], c=new_colors_scz)
            ax1.set_title('SCZ {} or not'.format(sx_list[i]), size=10.5)
            ax1.set_xticklabels('')
            ax1.set_xticks([])
            ax1.set_yticklabels('')
            ax1.set_yticks([])

            DecisionBoundaryDisplay.from_estimator(
                clf1,
                scz_embedded,
                plot_method="contour",
                colors="k",
                levels=[-1, 0, 1],
                alpha=0.5,
                linestyles=["--", "-", "--"],
                ax=ax1,
            )
    
    plt.savefig('results/fig1c.svg', format='svg', dpi=1200)
    
    return None

def manifold_bip(bip_embedded, num_sx_bip, new_bip_embedded1, new_num_sx_bip1, new_bip_embedded2, new_num_sx_bip2):
    fig,axes = plt.subplots(1,1,figsize=(3.5, 3.5))
    ax = axes

    sc = ax.scatter(bip_embedded[:, 0], bip_embedded[:, 1], c=num_sx_bip, cmap= plt.cm.rainbow)
    ax.set_title('BIP, number of Sx', size=11)
    ax.set_xticklabels('')
    ax.set_xticks([])
    ax.set_yticklabels('')
    ax.set_yticks([])
    ax.spines[['right', 'top']].set_visible(False)

    fig.subplots_adjust(right=0.85)
    cbar_ax = fig.add_axes([0.88, 0.12, 0.025, 0.25])
    fig.colorbar(sc, cax=cbar_ax)
    plt.savefig('results/fig2a.svg', format='svg', dpi=1200)

    fig,axes = plt.subplots(1,1,figsize=(3.5, 3.5))
    ax2 = axes

    sc2 = ax2.scatter(new_bip_embedded1[:, 0], new_bip_embedded1[:, 1], c=new_num_sx_bip1, cmap= plt.cm.rainbow)
    ax2.set_title('BIP (cluster 1)', size=10.5)
    ax2.set_xticklabels('')
    ax2.set_xticks([])
    ax2.set_yticklabels('')
    ax2.set_yticks([])
    ax2.spines[['right', 'top']].set_visible(False)

    fig.subplots_adjust(right=0.85)
    cbar_ax = fig.add_axes([0.88, 0.12, 0.025, 0.25])
    fig.colorbar(sc2, cax=cbar_ax)
    plt.savefig('results/fig2b.svg', format='svg', dpi=1200)

    fig,axes = plt.subplots(1,1,figsize=(3.5, 3.5))
    ax3 = axes

    sc3 = ax3.scatter(new_bip_embedded2[:, 0], new_bip_embedded2[:, 1], c=new_num_sx_bip2, cmap= plt.cm.rainbow)
    ax3.set_title('BIP (cluster 2)', size=10.5)
    ax3.set_xticklabels('')
    ax3.set_xticks([])
    ax3.set_yticklabels('')
    ax3.set_yticks([])
    ax3.spines[['right', 'top']].set_visible(False)

    fig.subplots_adjust(right=0.85)
    cbar_ax = fig.add_axes([0.88, 0.12, 0.025, 0.25])
    fig.colorbar(sc3, cax=cbar_ax)
    plt.savefig('results/fig2c.svg', format='svg', dpi=1200)

    return None

if __name__ == '__main__':

    # load schizophrenia
    df1 = pd.read_csv ('data/scz.csv', header=0, index_col=0)
    scz_input = df1.iloc[:, 2:].to_numpy()
    scz_label = np.zeros(len(scz_input))
    # load bipolar I disorder
    df2 = pd.read_csv ('data/bip.csv', header=0, index_col=0)
    bip_input = df2.iloc[:, 2:].to_numpy()
    bip_label = np.ones(len(bip_input))

    core_sx_scz = scz_input[:, 15]
    core_sx_bip = bip_input[:, 6]

    num_sx_scz = normalize(np.sum(scz_input, axis=1))
    num_sx_bip = normalize(np.sum(bip_input, axis=1))

    scz_embedded = UMAP(n_components=2, init='random', random_state=0).fit_transform(scz_input)
    bip_embedded = UMAP(n_components=2, init='random', random_state=0).fit_transform(bip_input)

    # extract cluster from bipolar I disorder
    clstr1 = bip_input[bip_embedded[:, 1] > -20, :]
    clstr2 = bip_input[bip_embedded[:, 1] < -20, :]
    new_num_sx_bip1 = normalize(np.sum(clstr1, axis=1))
    new_num_sx_bip2 = normalize(np.sum(clstr2, axis=1))
    new_bip_embedded1 = UMAP(n_components=2, init='random', random_state=0).fit_transform(clstr1)
    new_bip_embedded2 = UMAP(n_components=2, init='random', random_state=0).fit_transform(clstr2)

    # draw figure 1a
    manifold_scz(scz_embedded, num_sx_scz)

    # draw figure 1b
    manifold_core_sx(scz_input, scz_embedded)

    # draw figure 1c
    draw_svm(scz_input, scz_embedded)

    # draw supplementary figure 1
    draw_svm_supp(scz_input, scz_embedded)

    # draw figure 2
    manifold_bip(bip_embedded, num_sx_bip, new_bip_embedded1, new_num_sx_bip1, new_bip_embedded2, new_num_sx_bip2)
