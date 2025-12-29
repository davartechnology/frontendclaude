// lib/screens/feed/comment_item.dart

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago; 
import '../../config/theme.dart';
// IMPORTANT : Utilise le chemin de modèle correct
import '../../data/models/comment_model.dart'; 

class CommentItem extends StatelessWidget {
  final CommentModel comment;

  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    // Initialise TimeAgo en français (Assurez-vous que le package timeago est dans pubspec.yaml)
    timeago.setLocaleMessages('fr', timeago.FrMessages());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar de l'utilisateur
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.grey,
            // Utilise l'avatarUrl du UserModel
            backgroundImage: comment.user.avatarUrl != null 
                ? NetworkImage(comment.user.avatarUrl!) 
                : null,
            child: comment.user.avatarUrl == null
                ? const Icon(Icons.person, size: 20, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          
          // Contenu du commentaire
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nom d'utilisateur et date
                    Text(
                      '@${comment.user.username}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.grey,
                      ),
                    ),
                    Text(
                      timeago.format(comment.createdAt, locale: 'fr'),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Texte du commentaire
                Text(
                  comment.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Actions (Reply, Like)
                Row(
                  children: [
                    Text(
                      'Répondre',
                      style: TextStyle(
                        color: AppTheme.grey.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Bouton Like
                    GestureDetector(
                      onTap: () {
                        // TODO: Logique de like de commentaire
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 14,
                            color: AppTheme.grey.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likesCount}',
                            style: TextStyle(
                              color: AppTheme.grey.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}